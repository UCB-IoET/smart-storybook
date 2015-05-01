class CreateCommands < ActiveRecord::Migration
  def change
  	drop_table :commands
    create_table :commands do |t|
      t.integer :task_id
      t.integer :user_id
      t.text :code, :limit => 4294967295

      t.timestamps
    end
  end
end
