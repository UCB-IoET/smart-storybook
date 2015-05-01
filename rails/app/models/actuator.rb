class Actuator < ActiveRecord::Base
	mount_uploader :picture, PictureUploader
	has_one :experiment
	has_many :actuations
	has_many :behaviors, through: :flavors
	has_many :flavors

	def self.counts
		return Flavor.group(:actuator_id).count
	end
end
