require File.dirname(__FILE__) + '/../spec_helper'

describe UserSessionsController do

  describe "login" do
    it "should render new if session creation fails" do
      create_mock_session_for_create(false)
      post :create, :user_session => {}
      response.should render_template("new")
    end

    it "should redirect to root if logged in successfully" do
      create_mock_session_for_create
      post :create, "user_session" => {"email" =>"booga@wooga.com", "password" => "secret", "remember_me" => false}

      flash[:notice].should =~ /Login successful!/
      response.should be_redirect
      response.should redirect_to("/")
    end

    it "should redirect to previous page if logged in successfully" do
      create_mock_session_for_create
      set_up_prev_page
      post :create, "user_session" => {"email" =>"booga@wooga.com", "password" => "secret", "remember_me" => false}

      flash[:notice].should =~ /Login successful!/
      response.should be_redirect
      response.should redirect_to("/foo")
    end

    def set_up_prev_page
      @session = {}
      @controller.stub!(:session).and_return(@session)
      path = "/foo"
      path.stub!(:blank?).and_return(false)
      @session[:prevpage] = path
    end
  end

  describe "logout" do            
    it "should log out successfully" do                
      mock_session = mock(:UserSession) 
      mock_session.should_receive(:destroy)
      @controller.should_receive(:current_user_session).and_return(mock_session)
      delete :destroy

      flash[:notice].should =~ /Logout successful!/
      response.should be_redirect
      response.should redirect_to("login")      
    end
  end

  def create_mock_session_for_create(success=true)
    mock_session = mock(:UserSession)
    mock_session.should_receive(:save).and_return(success)
    mock_session.should_receive(:user)
    UserSession.should_receive(:new).and_return(mock_session)
  end
end
