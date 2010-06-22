class UsersController < ApplicationController
  before_filter :login_required, :only => ['show', 'update', 'setting']
  
  # render new.rhtml
  def new
    @user = User.new
    @page_title = "新用户注册"
  end
 
  def create
    logout_keeping_session!
    @user = User.new(params[:user])
    success = @user && @user.save
    if success && @user.errors.empty?
      # set first user as admin
      #@user.roles << Role.find_or_create_by_title('superuser') if User.count == 1
      @user.activate!
      redirect_to(login_url)
      flash[:notice] = "非常感谢您的注册，您现在可直接登录"
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end
  
  
  def update
    @user = current_user 
    
    if !@user.oauth_user? && !params[:current_password].blank? && 
        !params[:user][:password].blank? && !params[:user][:password_confirmation].blank?
      if User.authenticate(current_user.email, params[:current_password])
        @user.password = params[:user].delete(:password)
        @user.password_confirmation = params[:user].delete(:password_confirmation)
      else
        notice = '对不起，密码输入错误' if !params[:current_password].blank?
      end
    end
    
    @user.login = params[:user].delete(:login)
    @user.time_zone = params[:user].delete(:time_zone)
    
    # 只有用户没有设置Email地址时，才允许更新Email，主要针对豆瓣用户
    @user.email = params[:user][:email] if @user.email.blank? && !params[:user][:email].blank?
    
    respond_to do |wants|
      if @user.save
        notice ||= t(:update_success)
        flash[:notice] = notice       
        wants.html { redirect_to account_url }
      else
        flash[:notice] = notice
        wants.html{ render :action => "setting" }
      end
    end
  end
  
  def setting 
    @tab = 'account'
    @user = current_user
  end 
  
  def forget_password
    respond_to do |wants|
      wants.html { }
    end
  end
  
  def reset_password
    @user = User.find_by_email(params[:email])
    if @user
      new_password = User.generate_new_password
      @user.password = new_password
      @user.password_confirmation = new_password
      @user.save(:validate => false)
      Mailer.forget_password(@user, new_password).deliver
      cookies.delete :auth_token
      reset_session
      flash[:notice] = "新密码已发送到#{@user.email}"
      redirect_to root_url
    else
      flash.now[:error] = '找不到此email'
      render :action => "forget_password"
    end
  end
end
