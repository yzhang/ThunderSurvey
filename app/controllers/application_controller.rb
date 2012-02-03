class ApplicationController < ActionController::Base
  protect_from_forgery
  include AuthenticatedSystem
  include OauthHelper

  rescue_from ActionController::InvalidAuthenticityToken, :with => :token_expired

  before_filter :set_time_zone_and_locale

  protected
  def token_expired
    flash[:notice] = t(:session_timeout)
    respond_to do |accepts|
      accepts.html do
        store_location
        redirect_to(root_path) and return false
      end
    end
  end

  def set_time_zone_and_locale
    Time.zone = current_user.time_zone if logged_in?    
    I18n.locale = session[:locale] || 'zh-CN'
  end
  
  def set_section(section)
    @section = section
  end
  
  def verify_edit_key
    @edit_key = params[:edit_key]
    
    if @form.nil? || @form.edit_key != @edit_key
      flash[:notice] = t(:form_unauthorized)
      redirect_to '/'
    end
  end

  def render_404
    render_optional_error_file(404)
  end

  def render_403
    render_optional_error_file(403)
  end

  def render_optional_error_file(status_code)
    status = status_code.to_s
    if ["404","403", "422", "500"].include?(status)
      render :template => "/errors/#{status}.html.erb", :status => status, :layout => "application"
    else
      render :template => "/errors/unknown.html.erb", :status => status, :layout => "application"
    end
  end

end
