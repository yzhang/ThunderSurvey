require 'spec_helper'

describe Field do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :prompt => "value for prompt",
      :required => false,
      :input => "value for input"
    }
  end

  it "should create a new instance given valid attributes" do
    Field.create!(@valid_attributes)
  end
end
