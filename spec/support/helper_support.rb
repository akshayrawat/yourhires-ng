module HelperSupport

	def helper_instance(helper_class)
		Object.new.extend(helper_class)
	end

end