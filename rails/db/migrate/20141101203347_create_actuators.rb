class CreateActuators < ActiveRecord::Migration
  def change
    create_table :actuators do |t|
      t.string :name
      t.float :alpha
      t.string :img

      t.timestamps
    end
  end
end
