require File.dirname(__FILE__) + '/../spec_helper'

describe DashboardController do
  it "should render index" do
    login_admin
    get :index
    response.should_not redirect_to(Lockdown::System.fetch(:access_denied_path))
    response.should be_success
  end
end
