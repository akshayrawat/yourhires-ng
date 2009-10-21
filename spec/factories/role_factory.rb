class RoleFactory
  
  def self.developer
    Role.create!(:name => "developer")
  end
  
  def self.ba
    Role.create!(:name => "ba")    
  end
  
  def self.qa
    Role.create!(:name => "qa")    
  end

end