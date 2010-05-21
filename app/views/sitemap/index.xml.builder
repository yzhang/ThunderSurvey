xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do
  @forms.each do |form|
    xml.url do
      xml.loc form_url(form)
      xml.lastmod form.updated_at.to_date
    end
  end
end
