class FieldsController < ApplicationController
  before_filter :set_form
  
  def new
    @field = Field.new
  end
  
  def edit
    @field = @form.fields.find(params[:id])
  end
  
  def create
    @field = Field.new(params[:field])
    @form.fields << @field
    
    respond_to do |format|
      if @form.save
        format.html { redirect_to form_path(@form) }
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
      format.html {redirect_to edit_form_path(@form)}
    end
  end
  
  private
  def set_form
    @form = Form.find(params[:form_id])
  end
end
