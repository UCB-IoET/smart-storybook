class Command < ActiveRecord::Base
	belongs_to :user
	belongs_to :task
	validates_presence_of :task_id, :user_id, :code

	def code
		JSON.parse(self[:code])
	end
end
