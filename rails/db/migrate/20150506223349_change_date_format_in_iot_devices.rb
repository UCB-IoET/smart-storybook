class ChangeDateFormatInIotDevices < ActiveRecord::Migration
  def up
    change_column :iot_devices, :last_seen, :datetime
  end

  def down
    change_column :iot_devices, :last_seen, :time
  end
end
