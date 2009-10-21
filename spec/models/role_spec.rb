require File.dirname(__FILE__) + '/../spec_helper'

describe Role do
  it "should fail validation when name not specified" do
    role= Role.new
    
    role.should_not be_valid
    role.should have(1).error_on(:name)
  end
end
