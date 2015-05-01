class AddUserIdToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :user_id, :integer
    add_column :tasks, :completed, :boolean, :default => false
  end
end
