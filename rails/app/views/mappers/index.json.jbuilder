json.array!(@mappers) do |mapper|
  json.extract! mapper, :id
  json.url mapper_url(mapper, format: :json)
end
