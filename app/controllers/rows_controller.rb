class RowsController < ApplicationController
  before_filter :set_form
  before_filter :verify_edit_key, :only => [:index]

  def index
    klass = @form.klass
    @rows = klass.find(:all)
    
    respond_to do |want|
      want.html { render :layout => 'grid'}
      want.json {
        rows = []
        @rows.each_with_index do |row, i|
          cell = [i + 1]
          @form.fields.each { |field| cell << row.send("f#{field.id}") }
          rows << {:id => i + 1, :cell => cell}
        end
        
        data = {:page => 1, :total => 1, :records => klass.count, :rows => rows}
        render :json => data.to_json
      }
    end
  end
  
  def create
    klass = @form.klass
    @row = klass.new(params[:row])
    
    respond_to do |want|
      if @row.save
        want.html {redirect_to thanks_path}
      else
        want.html {render :template => '/forms/show',:layout => 'simple'}
      end
    end
  end
  
  private
  def set_form
    @form = Form.find(params[:form_id])
  end
end