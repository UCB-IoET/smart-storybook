class CreateTasks < ActiveRecord::Migration
  def change
  	drop_table :tasks
    create_table :tasks do |t|
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
