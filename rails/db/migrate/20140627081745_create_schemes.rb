class CreateSchemes < ActiveRecord::Migration
  def change
    create_table :schemes do |t|

      t.timestamps
    end
  end
end
