class Admin::FeedbacksController < Admin::BaseController  
  before_filter Proc.new{ @section = 'feedbacks' }  
  
  def index
    @feedbacks = Feedback.paginate(:per_page => 12,:page => params[:page], :order => 'created_at DESC')
    respond_to do |wants|
      wants.html
    end
  end   
  
  def destroy
    @feedback = Feedback.find(params[:id])
    @feedback.destroy
    respond_to do |wants|
      wants.html { redirect_to admin_feedbacks_url,:alert => '已删除' }
    end
  end   
end
