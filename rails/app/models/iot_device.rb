class IotDevice < ActiveRecord::Base
	validates_uniqueness_of :uuid
	
	def metadata
		return JSON.parse(self[:metadata]);
	end
end
