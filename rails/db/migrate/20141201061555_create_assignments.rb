class CreateAssignments < ActiveRecord::Migration
  def change
  	drop_table :assignments
    create_table :assignments do |t|
      t.integer :task_id
      t.integer :user_id
      t.boolean :completed, :default => false

      t.timestamps
    end
  end
end


