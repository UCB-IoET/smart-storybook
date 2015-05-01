json.array!(@tags) do |tag|
  json.extract! tag, :id, :behavior_id, :label
  json.url tag_url(tag, format: :json)
end
