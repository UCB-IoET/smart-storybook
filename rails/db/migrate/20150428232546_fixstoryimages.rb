class Fixstoryimages < ActiveRecord::Migration
  def up
    add_column :story_images, :story_page_id, :integer
  end

  def down
    remove_column :story_images, :story_id
  end
end
