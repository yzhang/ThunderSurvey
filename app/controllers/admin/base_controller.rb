class Admin::BaseController < ApplicationController
  before_filter :login_required
  access_control :DEFAULT => '(superuser)'
  layout 'admin'  
  
  def index                                       
    @section = 'dash'
    @recent_forms = Form.all(:limit => 10, :order => "created_at DESC")
    @recent_users = User.all(:limit => 10, :order => "created_at DESC")
  end
end