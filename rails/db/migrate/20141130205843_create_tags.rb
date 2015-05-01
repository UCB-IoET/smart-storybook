class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :behavior_id
      t.string :label

      t.timestamps
    end
  end
end
