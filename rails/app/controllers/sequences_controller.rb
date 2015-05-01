class SequencesController < ApplicationController

	def new
		@layer = "sequence"
		@behaviors = Behavior.all
		@behavior_attributes = Behavior.attribute_names
		@number_attributes = Behavior.get_number_attrs
		@notification_ordered = Behavior.get_top_notification
		@active_ordered = Behavior.get_top_active
		@unable_ordered = Behavior.get_top_unable
		@low_energy_ordered = Behavior.get_top_low_energy
		@turning_on_ordered = Behavior.get_top_turning_on
		@smooths = Behavior.get_smooths
	end

	def index
		@sequences = Sequence.all
	end

	def show
		@layer = "sequence"
		@sequence = Sequence.find(params[:id])
		@behaviors = @sequence.behaviors.to_json.html_safe
	end

	def create
		@sequence = Sequence.new
		@sequence.name = dehumanize params["sequence"]["name"]
		@sequence.behaviors = parse_names(Behavior, params["sequence"]["behaviors"])

		if !(@sequence.save)
			render	:json => { :error => @sequence.errors.full_messages.to_sentence }, 
							:status => :unprocessable_entity
		else
			render :json => { :status => :ok}
		end
	end

	def json_to_cpp
		cpp = Sequence.json_to_cpp params
		render :json => { :cpp => cpp}
	end

	def destroy
		@sequence = Sequence.find(params[:id])
		@sequence.destroy

		redirect_to sequences_path
	end

end
