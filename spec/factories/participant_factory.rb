class ParticipantFactory
	def self.create(params = {})
		Participant.create(valid_params.merge(params))
	end
	
	def self.valid_params
		{:email => "foo@bar.com"}
	end
end