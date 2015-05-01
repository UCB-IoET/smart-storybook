class CreateMappers < ActiveRecord::Migration
  def change
    create_table :mappers do |t|

      t.timestamps
    end
  end
end
