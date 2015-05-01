class CreateStoryImages < ActiveRecord::Migration
  def change
    create_table :story_images do |t|
      t.string :file
      t.string :size
      t.integer :story_id

      t.timestamps
    end
  end
end
