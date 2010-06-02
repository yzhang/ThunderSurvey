module ApplicationHelper
  def flash_div 
    flash.keys.collect { |key| content_tag( :div, flash[key], :class => "flash-msg #{key}" ) if flash[key] }.join
  end  
  
  def state_type(type)
    (type == ('alert' || 'error')) ? 'error' : 'highlight'
  end 
  
  def pretty_button(text,link,options = {})  
    deftault_options = options.reverse_merge!(:class=>'btn')
    link_to content_tag(:span,content_tag(:span,text)),link,deftault_options
  end
  
  def topnav_tab(name, options)
    classes = [options.delete(:class)]
    classes << 'current' if options[:section] && (options.delete(:section).to_a.include?(@section))
    content_tag(:li,link_to(content_tag(:span,name), options.delete(:url)),:class => classes.join(' '))
  end
     
  def pagenav_tab(name, options)
    classes = [options.delete(:class)]
    classes << 'highlight' if options[:tab] && (options.delete(:tab).to_a.include?(@tab))
    content_tag(:li,link_to(name, options.delete(:url),:class => options.delete(:href_class)),:class => classes.join(' '))
  end   
  
  def pagenav_area(&block)
    content_tag(:section, :id => "page_nav", &block)
  end
  
end
