class FieldsController < ApplicationController
  before_filter :set_form
  before_filter :verify_edit_key, :only => [:edit, :update, :index, :create]

  def index
    @fields = @form.fields
    
    respond_to do |want|
      want.json { render :json => @fields.to_json }
    end
  end
  
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
            page << '$("#saving").hide();'
            if @field.new_record?
              page.replace('last_field', :partial => 'field', :object => @field, :locals => {:parent => @form})
              page << "$('##{@field.id} .question').hide();"
              page << "$('##{@field.id} .form').show();"
              page << "$('##{@field.id}').css('background-color','#FDF2C6');"
            end
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
      if @field && @field.update_attributes(params[:field])
        @field.update_options(params[:options])
        format.js   {
          render :update do |page|
            page << '$("#saving").hide();'
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
      format.js {
        render :update do |page|
          page << "$('##{@field.id}.field').highlight(); $('##{@field.id}.field').fade();field_count -= 1;"
        end
      }
      format.json {render :json => @field.to_json}
    end
  end
  
  private
  def set_form
    @form = Form.find(params[:form_id])
  end
end
