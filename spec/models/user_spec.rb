require File.dirname(__FILE__) + '/../spec_helper'

describe User do    
  
  it "company should nest within a user" do
    user = User.new :email => 'foo@bar.com', :name => 'foo', :password => 'secret', :password_confirmation => "secret", 
                    :company_attributes => {:name => 'bar'}
    user.should be_valid
    user.save.should be_true
  end
  
  it "company should have error on missing name" do
    user = User.new :email => 'foo@bar.com', :name => 'foo', :password => 'secret', :password_confirmation => "secret", 
                    :company_attributes => {}
    user.save.should be_false
    user.company.should have(1).error_on(:name)
  end
end
