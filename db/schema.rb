ActiveRecord::Schema.define(:version => 1) do

  create_table "candidates", :force => true do |t|
    t.string   "name"
    t.integer  "role_id"
    t.string   "phone"
    t.string   "email"
    t.string   "source"
    t.string   "skillset"
    t.string   "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "candidates_recruiters", :id => false, :force => true do |t|
    t.integer  "recruiter_id"
    t.integer  "candidate_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "recruitment_step_id"
  end

  create_table "interviewers", :force => true do |t|
    t.integer "event_id"
    t.integer "participant_id"
  end

  create_table "participants", :force => true do |t|
    t.string "name"
  end

  create_table "recruiters", :force => true do |t|
    t.string  "name"
    t.string  "login",                                :null => false
    t.string  "email",                                :null => false
    t.string  "crypted_password",                     :null => false
    t.string  "password_salt",                        :null => false
    t.string  "persistence_token",                    :null => false
  end

  create_table "recruitment_step_types", :force => true do |t|
    t.string "name"
  end

  create_table "recruitment_steps", :force => true do |t|
    t.integer  "candidate_id"
    t.integer  "recruitment_step_type_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  
  create_table "resumes", :force  => true do |t|
    t.string  "document_file_name"
    t.string  "document_content_type"
    t.integer "document_file_size"
    t.datetime "document_updated_at"
  end
  
end
