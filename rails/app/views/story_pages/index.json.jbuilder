json.array!(@story_pages) do |story_page|
  json.extract! story_page, :id, :storytext_id, :storyimage_id, :storytype
  json.url story_page_url(story_page, format: :json)
end
