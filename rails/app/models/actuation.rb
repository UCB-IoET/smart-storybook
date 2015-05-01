class Actuation < ActiveRecord::Base
	belongs_to :flavor
	belongs_to :behavior
end