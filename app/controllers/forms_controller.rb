class FormsController < ApplicationController
  before_filter :login_required, :only => [:new, :create, :index, :destroy]
  before_filter :set_form, :only => [:edit, :update, :thanks]
  before_filter :verify_edit_key, :only => [:edit, :update] 
  before_filter { |c| c.set_section('forms') }
  
  def index   
    @forms = Form.all(:user_id => current_user.id.to_s,:order => 'created_at DESC').paginate(:page => params[:page], :per_page => '20')
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
    
    respond_to do |format|
      if @form && @form.allow_insert?
        @row = @form.klass.new
        @embed = params[:embed]
        @order_id = params[:order_id]
        format.html {  render :layout => params[:embed] ? 'embed' : 'public' }# show.html.erb
      else
<<<<<<< HEAD:app/controllers/forms_controller.rb
        flash[:notice] = "对不起，您访问的表单不存在"
        format.html { redirect_to root_path}
=======
        format.html { render :text => '对不起，此表单不允许插入新记录'}
      end
      
      if logged_in?
        format.json { render :json => @form.to_json }
      else
        format.json { render :json => 'Unauthorized' }
>>>>>>> 062f31537df42b380bd28d79b312212fbdc25001:app/controllers/forms_controller.rb
      end
      
      # format.json  do
      #   render :json => @form.to_json
      # end
    end
  end

  # GET /forms/new
  # GET /forms/new.xml
  def new    
    @form = current_user.forms.create(:title => "未命名问卷", :description => '描述一下你的问卷吧')

    @form.fields << Field.new(:name => '姓名', :required => true, :input => 'string', 
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
<<<<<<< HEAD:app/controllers/forms_controller.rb
    @fields = @form.fields
=======
    @fields = @form.fields#.sort {|f1, f2| f1.position <=> f2.position}
    @row = @form.klass.new
    
>>>>>>> 062f31537df42b380bd28d79b312212fbdc25001:app/controllers/forms_controller.rb
    respond_to do |want|
      want.html { render :layout => params[:embed].blank? ? 'simple' : "embed"}
    end
  end

  # PUT /forms/1
  # PUT /forms/1.xml
  def update
    respond_to do |format|
      if @form.update_attributes(params[:form])
        @form.sort_fields(params[:uuids])
        
        format.html { 
          flash[:notice] = 'Form was successfully updated.'
          redirect_to(@form) 
        }
        format.js {
          render :update do |page|  
            if params[:mod] == 'dialog' 
              page << "$('#notify_setting').dialog('close')"
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
    @form = Form.find(params[:id], :conditions => {:user_id => current_user.id.to_s})
    Form.delete(@form._id) if @form
    respond_to do |format|
      format.html { redirect_to(forms_url,:notice => '已删除') }
      format.json  { render :json => {:result => 'ok'}.to_json }
    end
  end
  
  def thanks
    respond_to do |want|
      want.html { render :layout => params[:embed] ? 'embed' : 'public' }
    end
  end
  
  private 
  def set_form
    @form = Form.find(params[:id])
  end
end
