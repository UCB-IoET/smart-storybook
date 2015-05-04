class SmapController < ApplicationController
	@@smap_server =  "http://shell.storm.pm:8079";
	@@query_api = "/api/query"

	@@host_server = "proj.storm.pm"
	@@data_port = "8081"

	
  def get_devices(query)
  	devices = post("#{@@smap_server}#{@@query_api}", query)
  	devices = JSON.parse(devices);
  	devices.select! do |c| 
  		if not c["Actuator"].nil? and (not c["Actuator"]["States"].nil?  or not c["Actuator"]["Values"].nil?) and c["Metadata"] and c["Metadata"]["Building"] == "IOET" and not c["Metadata"]["Name"].nil?  
  			c 
  		end 
  	end
  	return devices
  end


  def manifest
  	@devices = get_devices("select *")
  end

  def actuate
  	d = get_devices("select * where uuid='ee31c463-caef-5ed8-b6fb-70b2bf3fb99c'")[0];
	path = d["Path"]
	url = "/data#{path}?state=0"
  	render :json => http_put(url)

  end

def http_put(path)
		http = Net::HTTP.new(@@host_server, @@data_port)
		response = http.send_request('PUT', path);
	
		return {body: response.body, test: [@@host_server, @@data_port], path: path}
  end


  def post(url, query)
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
