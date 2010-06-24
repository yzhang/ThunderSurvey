class OptionsController < ApplicationController
  before_filter :set_field
  before_filter :verify_edit_key, :only => [:new, :destroy]
  
  def new
    @input = ['check', 'radio', 'drop'].include?(params[:input]) ? params[:input] : 'radio'
    @option = Option.new(:value => "#{t(:option)}#{@field.options.length + 1}")
    @field.options << @option
    @field.save
    
    respond_to do |want|
      want.html {
        render :partial => "/shared/#{@input}_option", :locals => {:parent => @form, :field => @field, :option => @option}
      }
    end
  end
  
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
