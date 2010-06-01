class Admin::UsersController < Admin::BaseController
  before_filter Proc.new{ @section = 'users' }
  
  def index  
    @users = User.paginate(:page => params[:page], :order => 'activated_at DESC')
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    respond_to do |wants|
      wants.html { redirect_to admin_users_url,:notice => '删除成功' }
    end
  end           
  
end
