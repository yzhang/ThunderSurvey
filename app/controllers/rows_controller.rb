class RowsController < ApplicationController
  before_filter :set_form
  before_filter :verify_edit_key, :only => [:index, :show]    
  skip_before_filter :verify_authenticity_token

  def index
    klass = @form.klass
    @rows = klass.paginate(:page => params[:page], :per_page => (params[:per_page]||20), :order => 'created_at')
    
    respond_to do |want|
      want.html { render :layout => params[:embed].blank? ? 'application' : "grid"}
      want.json {
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
    end
  end
  
  def show
    klass = @form.klass
    @row = klass.find(params[:id])
    
    respond_to do |wants|
      wants.json {render :json => @row.to_json}
    end
  end
  
  def create
    return update if params[:oper] == 'edit'
    return destroy if params[:oper] == 'del'
    
    params[:row][:created_at] = Time.now
    
    klass = @form.klass
    @row = klass.new(params[:row])
    
    respond_to do |want|
      if @form.allow_insert? && @row.save
        @res = @form.deliver_notification(@row)   
        # 这里返回到活动的感谢谢,res是返回的对应订单感谢地址
       # want.js {  render :js => "window.location='#{thanks_form_url(@form, :embed => true)}'" }
         want.js{ render :js =>  "window.location='#{@res}'" }
      else
        @embed = params[:embed]
        @order_id = @row.order_id
        want.html {render :template => '/forms/show',:layout => params[:embed].blank? ? 'simple' : 'embed' }
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
          end
           }
      end
    end
  end
  
  def update
    klass = @form.klass
    @row = klass.find(params.delete(:id))
    params.reject! do |k, v|
      !@row.respond_to?(k)
    end
    
    respond_to do |want|
      if @row.update_attributes(params)
        want.html {render :text => "success"}
        want.json {render :json => @row.to_json}
      else
        want.html {render :template => '/forms/show',:layout => 'simple'}
        want.json {render :json => @row.errors.to_json}
      end
    end
  end
  
  def destroy
    klass = @form.klass
    @row = klass.find(params[:id])
    klass.delete(@row._id) if @row
    
    respond_to do |want|
      want.html {render :text => "success"}
      want.json {render :json => [:ok]}
    end
  end
  
  private
  def set_form
    @form = Form.find(params[:form_id])
  end
end