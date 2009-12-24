# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 1) do

	create_table "candidates", :force => true do |t|
		t.string   "name"
		t.integer  "role_id"
		t.string   "phone"
		t.string   "email"
		t.string   "source"
		t.string   "skillset"
		t.string   "comments"
		t.string   "resume_file_name"
		t.string   "resume_content_type"
		t.integer  "resume_file_size"
		t.datetime "resume_updated_at"
		t.datetime "created_at"
		t.datetime "updated_at"
	end

	create_table "candidates_recruiters", :id => false, :force => true do |t|
		t.integer  "recruiter_id"
		t.integer  "candidate_id"
	end

	create_table "events", :force => true do |t|
		t.string   "venue"
		t.datetime "start_time"
		t.datetime "end_time"
		t.string	 "comment"
		t.integer  "recruitment_step_id"
		t.datetime "created_at"
		t.datetime "updated_at"
	end

	create_table "feedbacks", :force => true do |t|
		t.integer  "interviewer_id"
		t.text     "comment"
		t.datetime "created_at"
		t.datetime "updated_at"
	end

	create_table "interviewers", :force => true do |t|
		t.integer "event_id"
		t.integer "participant_id"
	end

	create_table "participants", :force => true do |t|
		t.string "name"
	end

	create_table "recruiters", :force => true do |t|
		t.string "name"
		t.string "login",             :null => false
		t.string "email",             :null => false
		t.string "crypted_password",  :null => false
		t.string "password_salt",     :null => false
		t.string "persistence_token", :null => false
	end

	create_table "recruitment_activities", :force => true do |t|
		t.integer  "candidate_id"
		t.text     "message"
		t.datetime "created_at"
		t.datetime "updated_at"
		t.string   "posted_by"
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
	end

end
