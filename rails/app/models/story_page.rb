class StoryPage < ActiveRecord::Base
	belongs_to :story
	has_many :story_images
	has_many :story_texts
end
