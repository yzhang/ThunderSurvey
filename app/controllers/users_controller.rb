class UsersController < ApplicationController
  before_filter :login_required, :only => ['show']
  
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
      redirect_back_or_default('/')
      flash[:notice] = "非常感谢您的注册，您的激活码已经发送到你的信箱"
    else
      flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
      render :action => 'new'
    end
  end

  def activate
    logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
  
  def show
    @bids = current_user.bids.paginate(:page => params[:page], :per_page => 10)
  end
end
