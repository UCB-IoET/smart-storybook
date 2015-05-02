class IotDevice < ActiveRecord::Base
	def metadata
		return JSON.parse(self[:metadata]);
	end
end
