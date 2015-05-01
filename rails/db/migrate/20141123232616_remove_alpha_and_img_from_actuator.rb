class RemoveAlphaAndImgFromActuator < ActiveRecord::Migration
  def change
    remove_column :actuators, :alpha, :float
    remove_column :actuators, :img, :string
  end
end
