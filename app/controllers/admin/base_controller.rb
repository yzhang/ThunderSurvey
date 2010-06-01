class Admin::BaseController < ApplicationController
  before_filter :login_required
  access_control :DEFAULT => '(superuser)'
  layout 'admin'
end