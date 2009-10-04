require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do                    
  before(:each) do
    @mock_user = mock(:User)                       
    @user_params = {:password_confirmation=>"secret", :company_attributes => {:name => "bar"}, :password => "secret", :email => "foo@bar.com"}
  end
                                                             
  it "should create a new company for a new user" do
    get :new
    assigns[:user].company.should_not be_nil
  end
  
  it "should be able to create an user successfully" do
    @mock_user.should_receive(:save).and_return(true)
    User.should_receive(:new).and_return(@mock_user)
    post :create, :user => @user_params.merge(:name => "foo")
    response.should be_redirect
    response.should redirect_to("dashboard")
    flash[:notice].should == 'User Registered!'
  end

  it "should render new if user creation fails" do
    @mock_user.should_receive(:save).and_return(false)
    User.should_receive(:new).and_return(@mock_user)
    post :create, :user => @user_params
    response.should be_unprocessable_entity
    response.should render_template("users/new")    
  end                               
end
