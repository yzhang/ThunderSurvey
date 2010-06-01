class Admin::FormsController < Admin::BaseController
  before_filter Proc.new{ @section = 'forms' }
  
  def index
    @forms = Form.paginate(:per_page => 25, :page => params[:page], :order => "updated_at DESC")
  end
  
  def destroy
    @form = Form.find(params[:id])
    Form.delete(@form._id) if @form
    
    respond_to do |format|
      format.html { redirect_to(admin_forms_url,:notice => '已删除') }
    end
  end
end