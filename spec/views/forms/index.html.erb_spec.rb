require 'spec_helper'

describe "/forms/index.html.erb" do
  include FormsHelper

  before(:each) do
    assigns[:forms] = [
      stub_model(Form,
        :title => "value for title",
        :description => "value for description"
      ),
      stub_model(Form,
        :title => "value for title",
        :description => "value for description"
      )
    ]
  end

  it "renders a list of forms" do
    render
    response.should have_tag("tr>td", "value for title".to_s, 2)
    response.should have_tag("tr>td", "value for description".to_s, 2)
  end
end
