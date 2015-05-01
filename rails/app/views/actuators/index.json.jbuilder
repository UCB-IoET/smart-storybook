json.array!(@actuators) do |actuator|
  json.extract! actuator, :id, :name, :alpha, :img
  json.url actuator_url(actuator, format: :json)
end
