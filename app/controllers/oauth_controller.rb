class OauthController < ApplicationController  
  def new
    provider = Provider.find(params[:name])
    provider.callback = oauth_callback_url(:name => params[:name])
    authorize_url = provider.authorize_url

    respond_to do |wants|
      session[:oauth_provider] = provider.dump
      wants.html {redirect_to authorize_url}
    end
  end
  
  def callback
    if session[:oauth_provider]
      begin
        provider = Provider.load(session[:oauth_provider])
        provider.authorize(params)
        reset_oauth_login
        reset_session
        session[:oauth_provider] = provider.dump
      rescue
        reset_oauth_login
        reset_session
      end
    end
    
    respond_to do |wants|
      if session[:oauth_provider]
        if current_user.email.blank?
          flash[:notice] = t(:please_set_email)
          wants.html { redirect_to account_url }
        else
          wants.html {redirect_to(forms_url,:notice => t(:login_success))}
        end
      else
        flash[:notice] = t(:oauth_failed)
        wants.html { redirect_to login_url}
      end
    end
  end
end