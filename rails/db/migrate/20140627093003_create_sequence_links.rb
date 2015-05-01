class CreateSequenceLinks < ActiveRecord::Migration
  def change
    create_table :sequence_links do |t|

      t.timestamps
    end
  end
end
