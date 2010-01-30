class FieldsController < ApplicationController
  before_filter :set_form
  before_filter :verify_edit_key, :only => [:new, :create, :edit, :update, :destroy]
  
  def new
    @field = Field.new(:name => "新问题#{@form.fields.count + 1}", :input => 'string')
    @form.fields << @field
    @form.save
    
    @form = Form.find(params[:form_id])
    @field = @form.fields.find(@field.id)
    
    respond_to do |want|
      want.html { render :partial => "/forms/field", :locals => {:parent => @form, :field => @field}, :layout => false}
    end
  end
  
  def edit
    @field = @form.fields.find(params[:id])
    
    respond_to do |want|
      want.html {render :layout => false}
    end
  end
  
  def update
    @field = @form.fields.find(params[:id])

    respond_to do |format|
      if @field.update_attributes(params[:field]) && @field.update_options(params[:options])
        format.html {redirect_to edit_form_path(@form)}
        format.js   {
          render :update do |page|
            page.replace(@field.id, :partial => '/forms/field', :object => @field, :locals => {:parent => @form})
            page.visual_effect('highlight', "question#{@field.id}")
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
