class CreateFlavors < ActiveRecord::Migration
  def change
    create_table :flavors do |t|
      t.integer :actuator_id
      t.float :alpha

      t.timestamps
    end
  end
end
