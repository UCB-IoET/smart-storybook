class Task < ActiveRecord::Base
	validates_presence_of :title, :description
	has_many :users, through: :assignments
	has_many :commands
end
