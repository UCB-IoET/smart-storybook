class AddNameToSequence < ActiveRecord::Migration
	def up
		add_column :sequences, :name, :string
	end
	def down
		remove_column :sequences, :name
	end
end
