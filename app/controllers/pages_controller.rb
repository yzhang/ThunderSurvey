class PagesController < ApplicationController
  respond_to :html        
  
  def show
    @page = Page.find_by_slug(params[:page]) 
    @section = params[:page]
    raise ActiveRecord::RecordNotFound if @page.nil?
    respond_with(@page)
  end
  
end
