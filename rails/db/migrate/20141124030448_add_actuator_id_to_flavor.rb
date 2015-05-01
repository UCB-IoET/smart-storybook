class AddActuatorIdToFlavor < ActiveRecord::Migration
  def change
    add_column :flavors, :actuator_id, :integer
  end
end
