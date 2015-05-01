json.array!(@experiments) do |experiment|
  json.extract! experiment, :id, :actuator_id, :physical_mag, :subjective_mag, :stimulus_cond, :continuum
  json.url experiment_url(experiment, format: :json)
end
