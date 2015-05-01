class CreateExperiments < ActiveRecord::Migration
  def change
    create_table :experiments do |t|
      t.integer :actuator_id
      t.string :physical_mag
      t.string :subjective_mag
      t.string :stimulus_cond
      t.string :continuum

      t.timestamps
    end
  end
end
