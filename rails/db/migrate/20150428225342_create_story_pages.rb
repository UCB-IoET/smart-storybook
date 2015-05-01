class CreateStoryPages < ActiveRecord::Migration
  def change
    create_table :story_pages do |t|
      t.integer :storytext_id
      t.integer :storyimage_id
      t.string :storytype

      t.timestamps
    end
  end
end
