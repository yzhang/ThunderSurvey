class HomeController < ApplicationController
  def index
  end

  def thanks
    respond_to do |want|
      want.html { render :layout => false}
    end
  end
end
