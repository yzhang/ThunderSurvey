class HomeController < ApplicationController
  def index       
    @section = 'home'
    redirect_to forms_url if logged_in?
  end
end
