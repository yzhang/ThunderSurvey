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
          flash[:notice] = "为保证您能顺利接收到我们的邮件，请您先设置您的Email"
          wants.html { redirect_to account_url }
        else
          wants.html {redirect_to(forms_url,:notice => '登录成功!')}
        end
      else
        flash[:notice] = "获取授权失败，请重新登录"
        wants.html { redirect_to login_url}
      end
    end
  end
end