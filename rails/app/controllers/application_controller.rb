class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :null_session

	def dehumanize(str)
		result = str.to_s.dup
		result.downcase.gsub(/ +/,'_')
	end

	def parse_names(model_type, name_array)
		behavior_array = []
		name_array.each do |name|
			behavior_array.push(model_type.find(name))
		end
		return behavior_array
	end

	def clean_data(param_hash)
		param_hash.attributes.except "created_at", "updated_at"
	end

	def index
	end

end