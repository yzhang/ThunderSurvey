class ApplicationController < ActionController::Base
  protect_from_forgery
  include AuthenticatedSystem
  include OauthHelper

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  rescue_from ActionController::InvalidAuthenticityToken, :with => :token_expired

  def token_expired
    flash[:notice] = "对不起，您的会话已超时"
    respond_to do |accepts|
      accepts.html do
        store_location
        redirect_to(root_path) and return false
      end
    end
  end
  
  before_filter :set_time_zone_and_locale

  protected
  def set_time_zone_and_locale
    Time.zone = current_user.time_zone if logged_in?
    
    lang = request.headers['Accept-Language'].split(',').first
    session[:locale] ||= ['en', 'zh-CN', 'zh-TW'].include?(lang) ? lang : 'en'
    I18n.locale = session[:locale]
  end
  
  def set_section(section)
    @section = section
  end
  
  def verify_edit_key
    @edit_key = params[:edit_key]
    
    if @form.edit_key != @edit_key
      flash[:notice] = "对不起，您没有权限操作此表单"
      redirect_to '/'
    end
  end
end
