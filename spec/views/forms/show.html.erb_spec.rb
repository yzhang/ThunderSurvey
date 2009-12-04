require 'spec_helper'

describe "/forms/show.html.erb" do
  include FormsHelper
  before(:each) do
    assigns[:form] = @form = stub_model(Form,
      :title => "value for title",
      :description => "value for description"
    )
  end

  it "renders attributes in <p>" do
    render
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ description/)
  end
end
