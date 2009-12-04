require 'spec_helper'

describe "/forms/new.html.erb" do
  include FormsHelper

  before(:each) do
    assigns[:form] = stub_model(Form,
      :new_record? => true,
      :title => "value for title",
      :description => "value for description"
    )
  end

  it "renders new form form" do
    render

    response.should have_tag("form[action=?][method=post]", forms_path) do
      with_tag("input#form_title[name=?]", "form[title]")
      with_tag("textarea#form_description[name=?]", "form[description]")
    end
  end
end
