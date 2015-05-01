class StoryImage < ActiveRecord::Base
	belongs_to :story_page
	mount_uploader :file, PictureUploader
end
