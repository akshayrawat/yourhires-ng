class ParticipantFactory
	def self.create(params = {})
		Participant.create(valid_params.merge(params))
	end
	
	def self.valid_params
		{:name => "foobar", :email => "foo@bar.com"}
	end
end