class AddStoryIdToStoryPages < ActiveRecord::Migration
  def change
    add_column :story_pages, :story_id, :integer
  end
end
