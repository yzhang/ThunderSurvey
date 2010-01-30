class FormsController < ApplicationController
  before_filter :login_required, :only => [:new, :create, :index, :destroy]
  before_filter :verify_edit_key, :only => [:edit, :update]
  
  # GET /forms
  # GET /forms.xml
  def index
    @forms = Form.find_all_by_user_id(current_user.id.to_s)

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
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @form }
    end
  end

  # GET /forms/new
  # GET /forms/new.xml
  def new
    @form = current_user.forms.create(:title => '未命名表单', :description => '描述一下你的表单吧')

    respond_to do |format|
      format.html { redirect_to edit_form_path(@form, :edit_key => @form.edit_key)}
      format.xml  { render :xml => @form }
    end
  end

  # GET /forms/1/edit
  def edit
    @field = Field.new
  end

  # POST /forms
  # POST /forms.xml
  def create
    @form = current_user.forms.build(params[:form])

    respond_to do |format|
      if @form.save
        flash[:notice] = 'Form was successfully created.'
        format.html { redirect_to(edit_form_path(@form)) }
        format.xml  { render :xml => @form, :status => :created, :location => @form }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /forms/1
  # PUT /forms/1.xml
  def update
    respond_to do |format|
      if @form.update_attributes(params[:form])
        format.html { 
          flash[:notice] = 'Form was successfully updated.'
          redirect_to(@form) 
        }
        format.js {
          render :update do |page|
            page.visual_effect('highlight', '.edit_form')
          end
        }
        format.xml  { render :xml => @form, :status => :updated, :location => @form }        
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @form.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /forms/1
  # DELETE /forms/1.xml
  def destroy
    @form = Form.find(params[:id])
    @form.destroy

    respond_to do |format|
      format.html { redirect_to(forms_url) }
      format.xml  { head :ok }
    end
  end
  
  private 
  def verify_edit_key
    @form = Form.find(params[:id])
    @edit_key = params[:edit_key]
    
    if @form.edit_key != @edit_key
      flash[:notice] = "对不起，您没有权限编辑此表单"
      redirect_to root_path
    end
  end
end
