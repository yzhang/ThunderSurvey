module FormsHelper    
  def render_required(field)
    content_tag(:span,:class => 'red') { "*" } if field.required
  end
end
