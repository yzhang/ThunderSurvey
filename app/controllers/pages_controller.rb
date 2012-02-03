class PagesController < ApplicationController
  respond_to :html        
  
  def show
    @page = Page.first(:slug => params[:page]) rescue nil

    if @page
      @page_title = @page.title
      @section = params[:page]
      respond_with(@page)
    else
      render_404
    end
  end
end
