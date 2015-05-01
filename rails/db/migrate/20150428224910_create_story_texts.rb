class CreateStoryTexts < ActiveRecord::Migration
  def change
    create_table :story_texts do |t|
      t.string :text
      t.integer :fontSize
      t.string :center
      t.string :textBackgroundHex
      t.float :textBackgroundAlpha
      t.integer :border
      t.string :story_page_id

      t.timestamps
    end
  end
end
