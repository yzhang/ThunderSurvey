class FieldsController < ApplicationController
  before_filter :set_form
  before_filter :verify_edit_key, :only => [:edit, :update, :destroy, :index, :create]

  def index
    @fields = @form.fields
    
    respond_to do |want|
      want.json { render :json => @fields.to_json }
    end
  end
  
  # def new
  #   @field = Field.new(:name => "新问题#{@form.fields.count + 1}", :input => 'string', :uuid => Time.now.to_i.to_s)
  #   
  #   respond_to do |want|
  #     want.html { render :partial => "/fields/field", :locals => {:parent => @form, :field => @field}, :layout => false}
  #   end
  # end
  
  def edit
    @field = @form.fields.find(params[:id])
    
    respond_to do |want|
      want.html {render :layout => false}
    end
  end
  
  def create
    @field = @form.find_field_by_uuid(params[:field][:uuid]) || Field.new(params[:field])
    
    if @field.new_record?
      @form.fields << @field
      result = @form.save
    else
      result = @field.update_attributes(params[:field])
    end
    
    respond_to do |format|
      if result
        @field.update_options(params[:options])
        format.js   {
          render :update do |page|
          end
        }
        format.json {render :json => @field.to_json}
      else
        format.html {render 'edit'}
      end
    end
  end
  
  def update
    @field = @form.fields.find(params[:id])

    respond_to do |format|
      if @field.update_attributes(params[:field])
        @field.update_options(params[:options])
        format.js   {
          render :update do |page|
          end
        }
        format.json {render :json => @field.to_json}
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
      format.json {render :json => @field.to_json}
    end
  end
  
  private
  def set_form
    @form = Form.find(params[:form_id])
  end
end
