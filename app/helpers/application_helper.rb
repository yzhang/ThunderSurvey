# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def flash_div 
    flash.keys.collect { |key| content_tag( :div, flash[key], :class => "flash-msg #{key}" ) if flash[key] }.join
  end
end
