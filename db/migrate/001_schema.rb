class Schema < ActiveRecord::Migration
	def self.up
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
			t.integer "recruiter_id"
			t.integer "candidate_id"
		end

		create_table "events", :force => true do |t|
			t.string   "venue"
			t.datetime "start_time"
			t.datetime "end_time"
			t.string   "comment"
			t.integer  "recruitment_step_id"
			t.string   "document_file_name"
			t.string   "document_content_type"
			t.integer  "document_file_size"
			t.datetime "document_updated_at"
			t.datetime "created_at"
			t.datetime "updated_at"
		end

		create_table "feedbacks", :force => true do |t|
			t.integer  "interviewer_id"
			t.text     "comment"
			t.string	 "feedback_result"
			t.datetime "created_at"
			t.datetime "updated_at"
		end

		create_table "interviewers", :force => true do |t|
			t.integer "event_id"
			t.integer "participant_id"
		end

		create_table "participants", :force => true do |t|
			t.string "name"
			t.string "email"
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
			t.string "name"
		end
	end

	def self.down
		drop_table "roles"
		drop_table "recruitment_steps"
		drop_table "recruitment_step_types"
		drop_table "recruitment_activities"
		drop_table "recruiters"
		drop_table "participants"
		drop_table "interviewers"
		drop_table "feedbacks"
		drop_table "events"
		drop_table "candidates_recruiters"
		drop_table "candidates"
	end
end
