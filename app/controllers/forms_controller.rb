class FormsController < ApplicationController
  before_filter :login_required, :only => [:new, :create, :index, :destroy, :chart]
  before_filter :set_form, :only => [:edit, :update, :thanks, :chart,:design]
  before_filter :verify_edit_key, :only => [:edit, :update] 
  before_filter { |c| c.set_section('forms') }
  
  def index   
    @forms = Form.all(:user_id => current_user.id.to_s,:order => 'created_at DESC').paginate(:page => params[:page], :per_page => '10')
    @page_title = "所有问卷"

    respond_to do |format|
      format.html
      format.xml  { render :xml => @forms }
    end
  end

  # GET /forms/1
  # GET /forms/1.xml
  def show
    @form = Form.find(params[:id]) rescue nil
    
    referrer = URI.parse(request.headers["HTTP_REFERER"].to_s) rescue URI.parse('')
    visit = Visit.create(:form_id => @form.id, :ip => request.remote_ip, :referrer => referrer.to_s, :host => referrer.host)
    
    respond_to do |format|
      if @form && !@form.password.blank? && session[@form.id] != @form.password
        format.html { render 'password', :layout => params[:embed] ? 'embed' : 'public'}
      elsif @form && @form.allow_insert?
        @row = @form.klass.new
        @embed = params[:embed]
        format.html {  render 'show', :layout => params[:embed] ? 'embed' : 'public' }# show.html.erb
      else
        flash[:notice] = t(:form_no_exist)
        format.html { redirect_to root_path}
      end
    end
  end
  
  def chart
    @tab = 'chart'
    respond_to do |format|
      if @form.klass.count.zero?
        format.html {redirect_to forms_path,:alert => '此问卷暂无回应'}
      else
        format.html
      end
    end
  end
  
  def password
    @form = Form.find(params[:id]) rescue nil
    
    respond_to do |format|
      if @form
        session[@form.id] = params[:password] if params[:password]
        format.html {redirect_to form_path(@form)}
      else
        flash[:notice] = "对不起，您访问的表单不存在"
        format.html { redirect_to root_path}
      end
    end 
  end

  # GET /forms/new
  # GET /forms/new.xml
  def new    
    @form = current_user.forms.create(:title => t(:untitled_form), :description => t(:describe_your_form))

    @form.fields << Field.new(:name => t(:name), :required => true, :input => 'string', 
              :uuid => Time.now.to_i,:position => 1)
    @form.fields << Field.new(:name => 'Email', :required => true, :input => 'string', 
              :uuid => Time.now.to_i + 5,:position => 2)
    @form.save
    
    @field = Field.new
    @row = @form.klass.new
    
    respond_to do |format|
      format.html { redirect_to edit_form_path(@form, :edit_key => @form.edit_key)}
      format.xml  { render :xml => @form }
    end
  end
  
  def create
    @form = current_user.forms.build(params[:form])
    
    respond_to do |format|
      if @form.save
        format.html { redirect_to edit_form_path(@form, :edit_key => @form.edit_key) }
        format.json { render :json => @form.to_json }
      else
        format.html { render :action => "new" }
        format.json  { render :json => @form.errors.to_json }
      end
    end
  end

  # GET /forms/1/edit
  def edit
    @row = @form.klass.new    
    @field = Field.new(:input => 'string')

    @fields = @form.fields
    
    respond_to do |want|
      if @form
        want.html { render :layout => params[:embed].blank? ? 'simple' : "embed"}
      else
        flash[:notice] = "对不起，您访问的表单不存在"
        format.html { redirect_to root_path}
      end
    end
  end   
  

  # PUT /forms/1
  # PUT /forms/1.xml
  def update
    respond_to do |format|
      if @form.update_attributes(params[:form])
        @form.sort_fields(params[:uuids])
        
        format.html { 
          flash[:notice] = t(:update_success)
          redirect_to(@form) 
        }
        format.js {
          render :update do |page|  
            if params[:mod] == 'dialog' 
              page << "$('#notify_setting').dialog('close')"
              page << "$('#password_setting').dialog('close')"
            end                                             
            page << '$("#saving").hide();'
          end
        }
        format.json  do
          render :json => @form.to_json
        end      
      else
        format.html { render :action => "edit" }
        format.js {
          render :update do |page|   
              page << "alert('#{@form.errors.full_messages}')"
          end
        }
        format.json  { render :json => @form.errors.to_json }
      end
    end
  end

  def destroy
    @form = Form.where(:id => params[:id], :user_id => current_user._id.to_s).first
    @form.destroy if @form
    
    respond_to do |format|
      format.html { redirect_to(forms_url,:notice => t(:removed)) }
      format.json  { render :json => {:result => 'ok'}.to_json }
    end
  end
  
  def thanks
    respond_to do |want|
      want.html { render :layout => 'public' }
    end
  end
  
  private 
  def set_form
    @form = Form.find(params[:id])
  end
end
