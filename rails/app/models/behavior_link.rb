class BehaviorLink < ActiveRecord::Base
	belongs_to :sequence
	belongs_to :behavior

	def self.next_link
		BehaviorLink.find(:position => self.position + 1)
	end
	
end
