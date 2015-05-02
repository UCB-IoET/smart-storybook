json.array!(@iot_devices) do |iot_device|
  json.extract! iot_device, :id, :uuid, :actuator_type, :metadata, :last_seen
  json.url iot_device_url(iot_device, format: :json)
end
