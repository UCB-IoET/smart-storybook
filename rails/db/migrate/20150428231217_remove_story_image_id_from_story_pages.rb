class RemoveStoryImageIdFromStoryPages < ActiveRecord::Migration
  def change
    remove_column :story_pages, :storyimage_id, :integer
    remove_column :story_pages, :storytext_id, :integer
  end
end
