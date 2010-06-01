class PagesController < ApplicationController
  respond_to :html        
  
  def show
    @page = Page.first(:slug => params[:page]) 
    @section = params[:page]
    respond_with(@page)
  end
end
