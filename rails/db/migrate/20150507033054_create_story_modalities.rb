class CreateStoryModalities < ActiveRecord::Migration
  def change
    create_table :story_modalities do |t|
      t.integer :actuator_id
      t.integer :strength
      t.integer :story_id
      t.integer :story_page_id

      t.timestamps
    end
  end
end
