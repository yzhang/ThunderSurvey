class ApplicationController < ActionController::Base
  protect_from_forgery
  
  include AuthenticatedSystem
  
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  protected
  def verify_edit_key
    @edit_key = params[:edit_key]
    
    if @form.edit_key != @edit_key
      flash[:notice] = "对不起，您没有权限操作此表单"
      redirect_to '/'
    end
  end
end
