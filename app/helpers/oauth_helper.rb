module OauthHelper
  def provider
    @provider ||= (session[:oauth_provider] && session[:oauth_provider][:access_token]) ? Provider.load(session[:oauth_provider]) : nil
  end
  
  def current_oauth_user
    @current_oauth_user ||= User.find_or_create_by_oauth(provider) if provider && provider.access_token
    @current_oauth_user
  end
  
  def oauth_authorized?
    !provider.nil?
  end
  
  def oauth_or_login_required
    oauth_authorized? || login_required
  end
  
  def reset_oauth_login
    @provider.destroy if @provider
    @provider = nil
    @current_oauth_user = nil
  end
end