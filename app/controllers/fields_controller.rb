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
        format.html {redirect_to @form}
      else
        format.html {render 'new'}
      end
    end
  end
  
  def destroy
    @field = @form.fields.find(params[:id])
    @form.fields.delete(@field) if @field
    @form.save
    
    respond_to do |format|
      format.html {redirect_to @form}
    end
  end
  
  private
  def set_form
    @form = Form.find(params[:form_id])
  end
end
