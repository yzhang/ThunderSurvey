class Admin::PagesController < Admin::BaseController
  respond_to :html
  before_filter Proc.new{ @section = 'pages' }

  def index
    respond_with(@pages = Page.all)
  end
  
  def new
    respond_with(@page = Page.new)
  end
  
  def create
    @page = Page.create(params[:page])
    respond_with(@page, :location => admin_pages_url)
  end
  
  def edit
    @page = Page.find(params[:id])
    respond_with(@page)
  end
  
  def update
    @page = Page.find(params[:id])
    @page.update_attributes(params[:page])         
    
    respond_to do |wants|      
      wants.html { redirect_to admin_pages_url,:notice => '已保存' }
    end
  end
  
  def destroy
    @page = Page.find(params[:id])
    @page.destroy
    respond_with(@page, :location => admin_pages_url)
  end
end