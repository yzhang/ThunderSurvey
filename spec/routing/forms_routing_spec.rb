require 'spec_helper'

describe FormsController do
  describe "routing" do
    it "recognizes and generates #index" do
      { :get => "/forms" }.should route_to(:controller => "forms", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/forms/new" }.should route_to(:controller => "forms", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/forms/1" }.should route_to(:controller => "forms", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/forms/1/edit" }.should route_to(:controller => "forms", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/forms" }.should route_to(:controller => "forms", :action => "create") 
    end

    it "recognizes and generates #update" do
      { :put => "/forms/1" }.should route_to(:controller => "forms", :action => "update", :id => "1") 
    end

    it "recognizes and generates #destroy" do
      { :delete => "/forms/1" }.should route_to(:controller => "forms", :action => "destroy", :id => "1") 
    end
  end
end
