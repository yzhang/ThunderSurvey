class AdminController < ApplicationController
  before_filter :login_required
  access_control :DEFAULT => '(superuser)'
  
  def index
  end
end