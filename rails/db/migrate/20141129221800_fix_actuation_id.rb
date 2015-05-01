class FixActuationId < ActiveRecord::Migration
 def self.up
    rename_column :actuations, :actuator_id, :flavor_id
  end

  def self.down
    rename_column :actuations, :flavor_id, :actuator_id
  end
end
