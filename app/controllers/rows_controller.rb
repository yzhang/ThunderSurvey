class RowsController < ApplicationController
  before_filter :set_form
  before_filter :verify_edit_key, :only => [:index, :show, :edit]    
  skip_before_filter :verify_authenticity_token  
  before_filter { |c| c.set_section('forms') }  

  def index
    @tab = 'answers'
    klass = @form.klass
    @rows = klass
    respond_to do |wants| 
      unless klass.count == 0
        wants.html { 
          @rows = klass.paginate(:page => params[:page], :per_page => (params[:per_page]||20), :order => 'created_at')
          render :layout => params[:embed] ? 'embed' : 'application' 
        }                   
      else
      wants.html {
        redirect_to forms_path,:alert => t(:no_answers)
      }                                        
     end
     
     wants.json {
       @rows = klass.paginate(:page => params[:page], :per_page => (params[:per_page]||20), :order => 'created_at')

       # 如果grid参数不为0，则为Grid调用，否则为ActiveResource
       if params[:grid] == '0'
          @rows << {:total_entries => @rows.total_entries}
          render :json => @rows.to_json
        else
          rows = []
          @rows.each_with_index do |row, i|
            cell = [row.id.to_s]
            cell << i + 1
            @form.fields.each { |field| cell << row.send("f#{field.id}") }
            cell << row.created_at
            cell << ''
            rows << {:id => row.id.to_s, :cell => cell}
          end
        
          data = {:page => 1, :total => 1, :records => klass.count, :rows => rows}
          render :json => data.to_json
        end
      }
      
      wants.csv do
        @rows = klass.paginate(:page => 1, :per_page => 1000, :order => 'created_at')
        csv_string = FasterCSV.generate(:col_sep => ",", :row_sep => "\r\n") do |csv|
          csv << (@form.fields.map(&:name) + [t(:timestamps)])
          first_page = @rows
          write_csv_rows(csv, first_page)
          (2..first_page.total_pages).to_a.each do |page|
            write_csv_rows(csv, klass.paginate(:page => page, :per_page => 1000, :order => 'created_at'))
          end
        end

        utf16_string = Iconv.iconv("UTF-16LE", "UTF-8", csv_string).join('')
        send_data("FFFE".gsub(/\s/,'').to_a.pack("H*") + utf16_string, :type => 'text/csv; charset=utf16; header=present')   
      end
      
      wants.xls {@rows = klass.paginate(:page => 1, :per_page => 1000, :order => 'created_at')}
    end
  end
  
  def show
    klass = @form.klass
    @row = klass.find(params[:id])
    
    respond_to do |wants|
      wants.html {render :partial => 'row', :locals => {:row => @row,:form => @form}, :layout => false}
      wants.json {render :json => @row.to_json}
    end
  end
  

  def edit
    @row = @form.klass.find(params[:id])
    
    respond_to do |wants|
      wants.html {}
    end
  end

  def create
    params[:row][:created_at] = Time.now
    @embed = params[:embed]
    klass = @form.klass
    @row = klass.new(params[:row])
    
    respond_to do |want|
      if @form.allow_insert? && @row.save
        @form.rows_count += 1
        @form.save(:validate => false)

        @form.deliver_notification(@row)
        params = ["form_id=#{@form.id}", "row_id=#{@row.id}","order_id=#{@row.order_id}"].join("&")
        want.js { render :js => "window.location='#{thanks_form_path(@form)}'" }
      else
        want.js { 
          render :update do |page|
            page.hide 'spinner'   
            @form.fields.each do |field|  
              if @row.errors["f#{field.id}"].any?
                page.replace_html field.id.to_s + '_field',@row.errors["f#{field.id}"]
              else
                page.replace_html field.id.to_s + '_field',''   
              end
            end     
            page.alert t(:something_goes_wrong)
          end
           }
      end
    end
  end
  
  def update
    klass = @form.klass
    @row = klass.find(params[:id])
    
    respond_to do |want|
      if @row.update_attributes(params[:row])
        want.html {redirect_to form_rows_path(@form, :edit_key => @form.edit_key),:notice => t(:update_success)}
        want.json {render :json => @row.to_json}
        want.js   {
          render :update do |page|
           # page['row'].replace_html(:partial => 'row', :locals => {:row => @row,:form => @form})
           flash[:notice] = t(:update_success)
           page.redirect_to(form_rows_path(@form, :edit_key => @form.edit_key))
          end
        }
      else
        want.html {render :action => 'edit'}
        want.json {render :json => @row.errors.to_json} 
        want.js {   
          render :update do |page| 
            page.hide 'spinner'   
            @form.fields.each do |field|  
              if @row.errors["f#{field.id}"].any?
                page.replace_html field.id.to_s + '_field',@row.errors["f#{field.id}"]
              else
                page.replace_html field.id.to_s + '_field',''   
              end
            end
            page << "alert('#{t(:something_goes_wrong)}')" 
          end
        }
      end
    end
  end
  
  def destroy
    klass = @form.klass
    @row = klass.find(params[:id])
    
    if @row
      klass.delete(@row._id) 
      @form.rows_count -= 1
      @form.save(:validate => false)
    end
    
    respond_to do |want|
      want.html {redirect_to form_rows_path(@form, :edit_key => @form.edit_key),:notice => t(:update_success)}
      want.json {render :json => [:ok]}
    end
  end
  
  protected
  def write_csv_rows(csv, rows)
    rows.each do |row|
      csv_row = []
      @form.fields.each do |field| 
        csv_row << row.send('f' + field.id.to_s)
      end
      csv << (csv_row + [row.created_at.to_time.to_formatted_s(:datetime_military)])
    end
  end
  
  private
  def set_form
    @form = Form.find(params[:form_id])
  end
end