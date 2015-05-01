class RemoveUserIdFromTasks < ActiveRecord::Migration
  def change
  	remove_column :tasks, :user_id
    remove_column :tasks, :completed
  end
end
