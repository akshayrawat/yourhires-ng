require 'spec_helper'

describe Company do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :description => "value for description",
      :logo_file_name => "value for logo_file_name",
      :logo_content_type => "value for logo_content_type",
      :logo_file_size => 1,
      :logo_updated_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    company = Company.new @valid_attributes
    company.should be_valid
    company.save.should be_true
  end                          
  
  it "should validate for presence of name" do
    company = Company.new @valid_attributes.reject{|k, v| k == :name}
    company.save.should be_false
    company.should have(1).error_on(:name)
  end
end
