require 'digest/md5'

class BehaviorsController < ApplicationController
	skip_before_filter :verify_authenticity_token, :only => :scanner
	before_filter :verify_custom_authenticity_token, :only => :scanner

	before_action :authenticate_user!, :only => :edit

def verify_custom_authenticity_token
	# checks whether the request comes from a trusted source
	python_password = "potatoes123"
	password = Digest::MD5.hexdigest(python_password)
	passed = params["auth"] == password
	return passed
end
	def new
		@behavior_attributes = Behavior.attribute_names
		@array_attributes = Behavior.get_array_attrs.to_json.html_safe
		@string_attributes = Behavior.get_string_attrs.to_json.html_safe
		@number_attributes = Behavior.get_number_attrs.to_json.html_safe
	end

	def new_stack
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

	def new_wave
		@layer = "behavior"
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

	def record_wave	
	end


	def scanner
		states = params["behavior"]["states"]
		@behavior = Behavior.new(behavior_params)
		@behavior.states = states
		
		if @behavior.save
			render :json => @behavior
		else
			render :json => { :error => @behavior.errors.full_messages.to_sentence, :vars => params }, 
							:status => :unprocessable_entity
		end
	end

	def create
		variables = behavior_params.clone
		variables["name"] = dehumanize variables["name"]
		variables["states"] = params["behavior"]["states"]

		@behavior = Behavior.new(variables)
		@behavior_attributes = Behavior.attribute_names

		if @behavior.save
			redirect_to @behavior
		else
			render :json => { :error => @behavior.errors.full_messages.to_sentence, :vars => params }, 
							:status => :unprocessable_entity
		end
	end

	def json_to_cpp
		# render :json => { :params => params}
		cpp = Behavior.json_to_cpp params
		render :json => { :cpp => cpp}
	end

	def show
		@behavior = Behavior.find(params[:id])
		respond_to do |format|
      	format.html # show.html.erb
      	format.json { render json: @behavior }
    end
    
	end

	def index
		@behaviors = Behavior.preload(:tags)
	end

	def edit
		@behavior = Behavior.find(params[:id])
	end

	def update
		@behavior = Behavior.find(params[:id])

		if @behavior.update(behavior_params)
			redirect_to @behavior
		else
			render 'edit'
		end
	end

	def destroy
		@behavior = Behavior.find(params[:id])
		@behavior.destroy

		redirect_to behaviors_path
	end

	def get_states
		@states = Behavior.find(params[:name])
		respond_to do |format|
			format.json { render :json => @states }
		end
	end

	def sparse
		alpha = params[:alpha] || 1
		sparse = Behavior.find_by_id(params[:behavior_id]).sparse(alpha)
		data =  {"sparse_commands" => sparse }
		respond_to do |format|
			format.json {render json: data}
		end
	end

	private
		def behavior_params
			params.require(:behavior).permit(:name, :notification, :active, :unable, :low_energy, :turning_on, :is_smooth, :states)
		end

end
