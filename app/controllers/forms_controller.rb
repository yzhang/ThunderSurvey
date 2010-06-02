class FormsController < ApplicationController
  before_filter :login_required, :only => [:new, :create, :index, :destroy]
  before_filter :set_form, :only => [:edit, :update, :thanks]
  before_filter :verify_edit_key, :only => [:edit, :update]
  
  def index
    @forms = Form.all(:user_id => current_user.id.to_s,:order => 'created_at DESC').paginate(:page => params[:page], :per_page => '20')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @forms }
    end
  end

  # GET /forms/1
  # GET /forms/1.xml
  def show
    @form = Form.find(params[:id])
    @row = @form.klass.new
    @embed = params[:embed]
    @order_id = params[:order_id]
    
    respond_to do |format|
      if @form.allow_insert?
        format.html {  render :layout => params[:embed] ? 'embed' : 'simple' }# show.html.erb
      else
        format.html { render :text => '对不起，此表单不允许插入新记录'}
      end
      format.json  do
        render :json => @form.to_json
      end
    end
  end

  # GET /forms/new
  # GET /forms/new.xml
  def new
    @form = current_user.forms.create(:title => "未命名表单", :description => '描述一下你的表单吧')
    @field = Field.new
    
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
    @field = Field.new(:input => 'string')
    @fields = @form.fields#.sort {|f1, f2| f1.position <=> f2.position}
    respond_to do |want|
      want.html { render :layout => params[:embed].blank? ? 'grid' : "embed"}
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
      want.html { render :layout => params[:embed] ? 'embed' : 'simple' }
    end
  end   
  
 
  
  private 
  def set_form
    @form = Form.find(params[:id])
  end
end
