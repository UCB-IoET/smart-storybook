class Tag < ActiveRecord::Base
	belongs_to :behavior
	validates_presence_of :behavior_id, :label
	validates_uniqueness_of :label, :scope => :behavior_id

	before_save do |tag| 
		tag.label.gsub!(/(.)([A-Z])/,'\1_\2')
		tag.label.gsub!(" ", "_")
     	tag.label.downcase!
 	end
 	def self.behaviors(flavor_id, label)
 		b_ids = Flavor.find(flavor_id).behaviors.collect{|b| b.id}

 		if(label == "all")
 			return Tag.where(:behavior_id => b_ids).collect{|b| b.behavior.metadata }
 		else
			return Tag.where(:behavior_id => b_ids, :label => label).collect{|b| b.behavior.metadata }
		end
	end
end
