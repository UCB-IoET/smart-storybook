# create_table "flavors", force: true do |t|
#   t.float    "alpha"
#   t.datetime "created_at"
#   t.datetime "updated_at"
#   t.string   "img"
#   t.integer  "actuator_id"
#   t.string   "name"
# end

class Flavor < ActiveRecord::Base
	belongs_to :actuator

	has_many :actuations
	has_many :behaviors, through: :actuations

	mount_uploader :img, PictureUploader

	validates_presence_of :actuator_id, :alpha

	def self.counts
		return  Actuation.group(:flavor_id).count
	end
	def tags
		b_ids = self.behaviors.collect{|b| b.id}
		results = Tag.where(:behavior_id => b_ids)
				  .select(:label);
		length = results.length
		results = results.inject(Hash.new(0)) { |total, e| total[e[:label]] += 1 ;total}
				  .collect{|x, t| {name: x.humanize, count: t, id: x}}
		results.unshift({name: "All", count: length,  id: "all"})
		return results
	end
	def tag_counts
	end
end
