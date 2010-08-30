# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem           

  def new
    @page_title = t(:login)
  end

  def create
    logout_keeping_session!
    user = User.authenticate(params[:email], params[:password])
    if user
      # Protects against session fixation attacks, causes request forgery
      # protection if user resubmits an earlier form using back
      # button. Uncomment if you understand the tradeoffs.
      # reset_session
      self.current_user = user
      #new_cookie_flag = (params[:remember_me] == "1")
      #handle_remember_cookie! new_cookie_flag
      redirect_back_or_default('/forms')
      flash[:notice] = t(:login_success)
    else
      note_failed_signin
      @email       = params[:email]
      @remember_me = params[:remember_me]
      render :action => 'new'
    end
  end

  def destroy
    logout_killing_session!
    flash[:notice] = t(:logout_success)
    redirect_back_or_default('/')
  end
  
  def set_lang
    lang = params[:locale]
    session[:locale] = ['en', 'zh-CN', 'zh-TW'].include?(lang) ? lang : 'en'
    redirect_to :back
  end

protected
  # Track failed login attempts
  def note_failed_signin
    flash[:alert] = t(:wrong_email_password)
    logger.warn "Failed login for '#{params[:login]}' from #{request.remote_ip} at #{Time.zone.now}"
  end
end
