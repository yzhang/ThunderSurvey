class OptionsController < ApplicationController
  before_filter :set_field
  
  def new
    @option = Option.new(:value => "选项#{@field.options.count + 1}")
    @field.options << @option
    @field.save
    
    respond_to do |want|
      want.html {
        render :partial => '/shared/radio_option', :locals => {:parent => @form, :field => @field, :option => @option}
      }
    end
  end
    
  # def create
  #   @option = Option.new(params[:option])
  #   @field.options << @option
  #   
  #   respond_to do |format|
  #     if @field.save
  #       format.html {redirect_to edit_form_field_path(@form, @field) }
  #     else
  #       format.html {render 'edit'}
  #     end
  #   end
  # end
  
  def destroy
    @option = @field.options.find(params[:id])
    @field.options.delete(@option) if @option
    @field.save
    
    respond_to do |format|
      format.html {render :text => 'successful.'}
    end
  end
  
  private
  def set_field
    @form = Form.find(params[:form_id])
    @field = @form.fields.find(params[:field_id])
  end
end
