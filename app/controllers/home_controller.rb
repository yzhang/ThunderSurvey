# coding: utf-8
class HomeController < ApplicationController
  
  before_filter :redirect_if_loggin,:only => [:demo]
  
  def index             
    @section = 'home' 
    @recommanded_forms = Form.all(:recommanded => true,:limit => 10,:order => 'updated_at DESC')
  end
  
  def demo      
    user = User.new(:login => "DemoUser#{Time.now.to_i}")
    user.save(:validate => false)
    self.current_user = user
    
    respond_to do |wants|
      wants.html {redirect_to forms_url}
    end
  end   
  protected
  
  def redirect_if_loggin
    redirect_to forms_url,:notice => t("account_already_exist") if logged_in?
  end
end
