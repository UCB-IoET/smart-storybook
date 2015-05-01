class AddPictureToActuators < ActiveRecord::Migration
  def change
    add_column :actuators, :picture, :string
  end
end
