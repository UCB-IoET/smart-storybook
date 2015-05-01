# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'json'

f = IO.read("public/lightbehaviors_harrison.json")
lb_hash = JSON.parse f

SCALING_FACTOR = 1
SMOOTH_WAVES = ["fast_in_slow_out", "lighthouse", "pulse", "pulse_fast",
				"pulse_slow"]

Behavior.destroy_all

lb_hash.each do |key, value|
	name = key.sub(/\/lb\/LB_/, '').sub(/\.svg/, '').underscore
	smooth = SMOOTH_WAVES.include?(name.underscore)
	# normalize states to range 0.0 to 1.0, then multiply by scaling factor
	states_min = value.min
	states_max = value.max
	states = value.map do |el|
		el -= states_min
		el /= states_max
		el *= SCALING_FACTOR
	end
	Behavior.create!(:name => name, :is_smooth => smooth, :states => states,
						:is_library => true)
end