class Admin::UsersController < Admin::BaseController
  before_filter Proc.new{ @section = 'users' }
  
  def index  
    @users = User.paginate(:page => params[:page], :order => 'activated_at DESC')
  end
  
  def destroy
    @user = User.find(params[:id])

    @user.forms.each do |f|
      f.destroy
    end
    
    @user.destroy
    respond_to do |wants|
      wants.html { redirect_to admin_users_url,:notice => '删除成功' }
    end
  end    
  
  def show
    @user = User.find(params[:id])
    @form_count = Form.all(:user_id => @user.id.to_s).count
    @forms = Form.all(:user_id => @user.id.to_s,:order => 'created_at DESC').paginate(:page => params[:page], :per_page => '20')
    
    respond_to do |wants|
      wants.html {  }
    end
  end       
  
end
