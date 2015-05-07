json.array!(@story_modalities) do |story_modality|
  json.extract! story_modality, :id, :actuator_id, :strength, :story_id, :page_number
  json.url story_modality_url(story_modality, format: :json)
end
