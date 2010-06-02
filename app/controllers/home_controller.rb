class HomeController < ApplicationController
  layout 'grid' 
  
  def index
    redirect_to forms_url if logged_in?
  end
end
