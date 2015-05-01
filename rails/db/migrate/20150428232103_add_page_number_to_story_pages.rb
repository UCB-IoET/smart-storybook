class AddPageNumberToStoryPages < ActiveRecord::Migration
  def change
    add_column :story_pages, :page_number, :integer
  end
end
