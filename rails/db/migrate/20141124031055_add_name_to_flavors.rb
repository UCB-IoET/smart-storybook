class AddNameToFlavors < ActiveRecord::Migration
  def change
    add_column :flavors, :name, :string
  end
end
