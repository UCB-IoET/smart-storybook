class CreateBehaviorLinks < ActiveRecord::Migration
  def change
    create_table :behavior_links do |t|
      t.integer :position

      t.timestamps
    end
  end
end
