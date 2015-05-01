json.array!(@story_texts) do |story_text|
  json.extract! story_text, :id, :text, :fontSize, :center, :textBackgroundHex, :textBackgroundAlpha, :border, :story_id
  json.url story_text_url(story_text, format: :json)
end
