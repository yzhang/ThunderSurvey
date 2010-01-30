class FieldsController < ApplicationController
  before_filter :set_form
  before_filter :verify_edit_key, :only => [:new, :create, :edit, :update, :destroy]
  
  def new
    @field = Field.new
  end
  
  def edit
    @field = @form.fields.find(params[:id])
    
    respond_to do |want|
      want.html {render :layout => false}
    end
  end
  
  def create
    @field = Field.new(params[:field])
    @form.fields << @field
    
    respond_to do |format|
      if @form.save
        format.html { redirect_to form_path(@form) }
        format.js {
          render :update do |page|
            page.insert_html(:bottom, 'fields', :partial => '/forms/field', :object => @field)
            page.visual_effect('highlight', @field.id)
            page << '$("#form_container").toggle();'
          end
        }
      else
        format.html { render 'new' }
      end
    end
  end
  
  def update
    @field = @form.fields.find(params[:id])
    
    respond_to do |format|
      if @field.update_attributes(params[:field])
        format.html {redirect_to edit_form_path(@form)}
        format.js   {
          render :update do |page|
            page.replace_html(@field.id, :partial => '/forms/field', :object => @field)
            page.visual_effect('highlight', @field.id)
            page << "$('#field_form#{@field.id}').hide();"
          end
        }
      else
        format.html {render 'edit'}
      end
    end
  end
  
  def destroy
    @field = @form.fields.find(params[:id])
    @form.fields.delete(@field) if @field
    @form.save
    
    respond_to do |format|
      format.html {render :text => "Successful."}
    end
  end
  
  private
  def set_form
    @form = Form.find(params[:form_id])
  end
  
  def verify_edit_key
    @edit_key = params[:edit_key]
    
    if @form.edit_key != @edit_key
      flash[:notice] = "对不起，您没有权限编辑此表单"
      redirect_to root_path
    end
  end
end
