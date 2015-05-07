class StoryModality < ActiveRecord::Base
	belongs_to :story_page
	belongs_to :actuator

	validates_uniqueness_of :actuator_id, :scope => [:story_page_id]
	validates :actuator_id, presence: true
end
