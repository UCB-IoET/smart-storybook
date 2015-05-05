class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :null_session
	@@host_server = "proj.storm.pm"
	@@data_port = "8081"
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
	def http_get(path)
		http_action("GET", path)
	end

	def http_put(path)
		http_action("PUT", path)
	end

	def http_action(rest_tag, path)
		http = Net::HTTP.new(@@host_server, @@data_port)
		response = http.send_request(rest_tag, path);
		if not response.nil?
			response = response.body
		end
		return  response
	end

	def http_post(url, query)
		uri = URI(url);

		req = Net::HTTP::Post.new(uri)
		post_body = [query]
		req.body = post_body.join
		req.content_type = 'text/html; charset=utf-8'

		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
		http.request(req)
		end

		return res.body
	end

end