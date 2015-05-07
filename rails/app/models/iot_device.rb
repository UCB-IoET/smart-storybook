class IotDevice < ActiveRecord::Base
	validates_uniqueness_of :uuid
	
	def metadata
		if not self[:metadata].nil?
			return JSON.parse(self[:metadata])
		else 
			return {}
		end
	end
end
