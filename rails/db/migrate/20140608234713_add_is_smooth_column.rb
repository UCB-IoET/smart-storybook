class AddIsSmoothColumn < ActiveRecord::Migration
  def up
  	add_column :behaviors, :is_smooth, :boolean
  end
  def down
  	remove_column :behaviors, :is_smooth
  end
end
