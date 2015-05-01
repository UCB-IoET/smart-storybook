json.array!(@commands) do |command|
  json.extract! command, :id, :task_id, :user_id, :code
  json.url command_url(command, format: :json)
end
