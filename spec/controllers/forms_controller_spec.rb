require 'spec_helper'

describe FormsController do

  def mock_form(stubs={})
    @mock_form ||= mock_model(Form, stubs)
  end

  describe "GET index" do
    it "assigns all forms as @forms" do
      Form.stub!(:find).with(:all).and_return([mock_form])
      get :index
      assigns[:forms].should == [mock_form]
    end
  end

  describe "GET show" do
    it "assigns the requested form as @form" do
      Form.stub!(:find).with("37").and_return(mock_form)
      get :show, :id => "37"
      assigns[:form].should equal(mock_form)
    end
  end

  describe "GET new" do
    it "assigns a new form as @form" do
      Form.stub!(:new).and_return(mock_form)
      get :new
      assigns[:form].should equal(mock_form)
    end
  end

  describe "GET edit" do
    it "assigns the requested form as @form" do
      Form.stub!(:find).with("37").and_return(mock_form)
      get :edit, :id => "37"
      assigns[:form].should equal(mock_form)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created form as @form" do
        Form.stub!(:new).with({'these' => 'params'}).and_return(mock_form(:save => true))
        post :create, :form => {:these => 'params'}
        assigns[:form].should equal(mock_form)
      end

      it "redirects to the created form" do
        Form.stub!(:new).and_return(mock_form(:save => true))
        post :create, :form => {}
        response.should redirect_to(form_url(mock_form))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved form as @form" do
        Form.stub!(:new).with({'these' => 'params'}).and_return(mock_form(:save => false))
        post :create, :form => {:these => 'params'}
        assigns[:form].should equal(mock_form)
      end

      it "re-renders the 'new' template" do
        Form.stub!(:new).and_return(mock_form(:save => false))
        post :create, :form => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested form" do
        Form.should_receive(:find).with("37").and_return(mock_form)
        mock_form.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :form => {:these => 'params'}
      end

      it "assigns the requested form as @form" do
        Form.stub!(:find).and_return(mock_form(:update_attributes => true))
        put :update, :id => "1"
        assigns[:form].should equal(mock_form)
      end

      it "redirects to the form" do
        Form.stub!(:find).and_return(mock_form(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(form_url(mock_form))
      end
    end

    describe "with invalid params" do
      it "updates the requested form" do
        Form.should_receive(:find).with("37").and_return(mock_form)
        mock_form.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :form => {:these => 'params'}
      end

      it "assigns the form as @form" do
        Form.stub!(:find).and_return(mock_form(:update_attributes => false))
        put :update, :id => "1"
        assigns[:form].should equal(mock_form)
      end

      it "re-renders the 'edit' template" do
        Form.stub!(:find).and_return(mock_form(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested form" do
      Form.should_receive(:find).with("37").and_return(mock_form)
      mock_form.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the forms list" do
      Form.stub!(:find).and_return(mock_form(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(forms_url)
    end
  end

end
