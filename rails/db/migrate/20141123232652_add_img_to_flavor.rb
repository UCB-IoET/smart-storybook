class AddImgToFlavor < ActiveRecord::Migration
  def change
    add_column :flavors, :img, :string
  end
end
