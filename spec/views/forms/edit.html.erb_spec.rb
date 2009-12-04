require 'spec_helper'

describe "/forms/edit.html.erb" do
  include FormsHelper

  before(:each) do
    assigns[:form] = @form = stub_model(Form,
      :new_record? => false,
      :title => "value for title",
      :description => "value for description"
    )
  end

  it "renders the edit form form" do
    render

    response.should have_tag("form[action=#{form_path(@form)}][method=post]") do
      with_tag('input#form_title[name=?]', "form[title]")
      with_tag('textarea#form_description[name=?]', "form[description]")
    end
  end
end
