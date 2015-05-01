json.array!(@flavors) do |flavor|
  json.extract! flavor, :id, :name, :alpha
  json.url flavor_url(flavor, format: :json)
end
