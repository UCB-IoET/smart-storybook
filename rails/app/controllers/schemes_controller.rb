class SchemesController < ApplicationController

	def new
		@layer = "Scheme"
		@sequences = Scheme.get_sequence_hash
	end

	def index
		@schemes = Scheme.all
	end

	def show
		@scheme= Scheme.find(params[:id])
		@sequences = @scheme.sequences.to_json.html_safe
	end

	def create
		@scheme = Scheme.new
		@sequence.name = dehumanize params["scheme"]["name"]
		@sequence.behaviors = parse_names(Sequence, params["scheme"]["sequences"])

		if !(@scheme.save)
			render	:json => { :error => @scheme.errors.full_messages.to_sentence }, 
							:status => :unprocessable_entity
		end
	end

	def destroy
		@scheme = Scheme.find(params[:id])
		@scheme.destroy

		redirect_to schemes_path
	end

end