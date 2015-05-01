json.array!(@story_images) do |story_image|
  json.extract! story_image, :id, :file, :size, :story_id
  json.url story_image_url(story_image, format: :json)
end
