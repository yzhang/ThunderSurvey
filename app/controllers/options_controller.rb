class OptionsController < ApplicationController
  before_filter :set_field
    
  def create
    @option = Option.new(params[:option])
    @field.options << @option
    
    respond_to do |format|
      if @field.save
        format.html {redirect_to @form }
      else
        format.html {render 'edit'}
      end
    end
  end
  
  def destroy
    @option = @field.options.find(params[:id])
    @field.options.delete(@option) if @option
    @field.save
    
    respond_to do |format|
      format.html {redirect_to @form}
    end
  end
  
  private
  def set_field
    @form = Form.find(params[:form_id])
    @field = @form.fields.find(params[:field_id])
  end
end
