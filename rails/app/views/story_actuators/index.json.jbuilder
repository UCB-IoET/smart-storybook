json.array!(@story_actuators) do |story_actuator|
  json.extract! story_actuator, :id, :uuid, :state, :story_page_id
  json.url story_actuator_url(story_actuator, format: :json)
end
