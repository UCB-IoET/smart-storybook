json.array!(@actuations) do |actuation|
  json.extract! actuation, :id, :behavior_id, :actuator_id
  json.url actuation_url(actuation, format: :json)
end
