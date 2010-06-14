class Admin::BaseController < ApplicationController
  before_filter :login_required
  access_control :DEFAULT => '(superuser)'
  layout 'admin'  
  
  def index
  #  @today_forms = Form.all(:conditions => "created_at < #{Date.today}")
  end
end