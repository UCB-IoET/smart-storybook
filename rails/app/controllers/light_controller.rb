class LightController < ApplicationController
	def view
	end
	def wave
		@lb = "foo"
	end
	def lb
		@lp = Dir['public/lb/*.svg'].map{|e| "/" + e.split('/')[1..-1].join('/') };
		@lp = @lp.to_json.html_safe# render :json => @lb
	end
	
	
	def sequence
		@layer = "Sequence"
		@behaviors = Behavior.all
		@behavior_attributes = Behavior.attribute_names
		@number_attributes = Behavior.get_number_attrs
		@notification_ordered = Behavior.get_top_notification
		@active_ordered = Behavior.get_top_active
		@unable_ordered = Behavior.get_top_unable
		@low_energy_ordered = Behavior.get_top_low_energy
		@turning_on_ordered = Behavior.get_top_turning_on
		@smooths = Behavior.get_smooths
		render "/sequences/new"
	end
	def synthesize
		@layer = "Behavior"
		@behaviors = Behavior.all
		@behavior_attributes = Behavior.attribute_names
		@number_attributes = Behavior.get_number_attrs
		@notification_ordered = Behavior.get_top_notification
		@active_ordered = Behavior.get_top_active
		@unable_ordered = Behavior.get_top_unable
		@low_energy_ordered = Behavior.get_top_low_energy
		@turning_on_ordered = Behavior.get_top_turning_on
		render "/behaviors/new_wave"
	end

	def create
		variables = behavior_params # ensure that data passed from $.ajax()
																# meets strong parameter requirements
		variables["name"] = BehaviorsController.dehumanize variables["name"]
		@behavior = Behavior.new(variables)
		@behavior_attributes = Behavior.attribute_names
		if @behavior.save
			render status: 200, json: { :message => "OK" }
		else
			render status: 500, json: { :message => "BAD" }
		end
	end

	private
		def behavior_params
			params.require(:behavior).permit(:name, :notification, :active,
				:unable, :low_energy, :turning_on, :is_smooth, :states)
		end

		def self.dehumanize(str)
			result = str.to_s.dup
			result.downcase.gsub(/ +/,'_')
		end

end