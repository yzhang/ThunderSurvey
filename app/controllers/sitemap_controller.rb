class SitemapController < ApplicationController
  def index
    @forms = Form.all(:order => "updated_at DESC", :limit => 50000)
    respond_to do |wants|
      wants.xml
    end
  end
end