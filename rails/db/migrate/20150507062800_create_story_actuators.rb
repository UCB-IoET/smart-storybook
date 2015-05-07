class CreateStoryActuators < ActiveRecord::Migration
  def change
    create_table :story_actuators do |t|
      t.string :uuid
      t.string :state
      t.string :story_page_id

      t.timestamps
    end
  end
end
