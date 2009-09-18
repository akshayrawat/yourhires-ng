class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string    :name,               :null => false 
      t.string    :email,               :null => false
      t.string    :crypted_password,    :null => false
      t.string    :password_salt,       :null => false
      t.string    :persistence_token,   :null => false  # required
      t.string    :perishable_token,    :null => false 
      t.integer   :failed_login_count,  :null => false, :default => 0 
      t.datetime  :last_request_at 
      t.timestamps
    end

    add_index :users, :perishable_token
    add_index :users, :email    

    super_admin = User.create \
              :name => 'super_admin',
              :email => 'super_admin@yourhires.com',
              :password => 'p@ssw0rd',
              :password_confirmation => 'p@ssw0rd'
  end


  def self.down
    drop_table :users
  end
end