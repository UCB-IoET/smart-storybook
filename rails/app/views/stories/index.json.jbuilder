json.array!(@stories) do |story|
  json.extract! story, :id, :title, :author
  json.url story_url(story, format: :json)
end
