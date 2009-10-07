class CreateTables < ActiveRecord::Migration
  def self.up
    create_table :candidates, :force => true do |t|
      t.string :name
      t.timestamps      
    end
    
    create_table :recruitment_step_types, :force => true do |t|
      t.string :name
    end

    create_table :recruitment_steps, :force => true do |t|
      t.references :candidate
      t.references :recruitment_step_type
      t.string :status
      t.timestamps
    end
    
    create_table :events, :force => true do |t|
      t.string :name
      t.timestamps
      t.references :recruitment_step
    end
    
    create_table :participants, :force => true do |t|
      t.string :name
    end

    create_table :interviewers, :force => true do |t|
      t.references :event
      t.references :participant
    end
        
    create_table :recruiters, :force => true do |t|
      t.string :name
    end
    
    create_table :recruiter_assignments, :force => true do |t|
      t.references :recruiters
      t.references :candidates
      t.timestamps
    end
  end

  def self.down
    drop_table :recruiter_assignments
    drop_table :recruiters
    drop_table :interviewers
    drop_table :recruitment_step_types
    drop_table :participants
    drop_table :recruitment_steps
    drop_table :events
    drop_table :candidates
  end
end
