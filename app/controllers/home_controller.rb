class HomeController < ApplicationController
  def index             
    @section = 'home' 
    @recommanded_forms = Form.all(:recommanded => true,:limit => 10)
    redirect_to forms_url if logged_in?
  end
  
  def demo
    user = User.new(:login => "临时用户#{Time.now.to_i}")
    user.save(:validate => false)
    self.current_user = user
    
    respond_to do |wants|
      wants.html {redirect_to forms_url}
    end
  end
end
