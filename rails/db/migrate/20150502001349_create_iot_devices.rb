class CreateIotDevices < ActiveRecord::Migration
  def change
    create_table :iot_devices do |t|
      t.string :uuid
      t.string :actuator_type
      t.string :metadata
      t.time :last_seen

      t.timestamps
    end
  end
end
