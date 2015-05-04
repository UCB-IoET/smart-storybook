class SmapController < ApplicationController
@@devices_file = 'public/devices.json';
	@@smap_server =  "http://shell.storm.pm:8079";
	@@query_api = "/api/query"
	@@actuation_api = "/add/apikey"

	
  def get_devices
  	query = "select *"
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
  	@devices = get_devices
  end

  def actuate
  	act = get_devices[1];

  	act = {'/actuate'=>  
  			{
  				'uuid'=>  act["uuid"],
                'Readings'=>  [[Time.now(), 1]],
                'Properties'=>  act["Properties"],
                'Metadata'=> {'override'=>  act["uuid"]}
            }
        }  
    render :json => { uuid: act, url: "#{@@smap_server}#{@@actuation_api}",  
    				request: post2("#{@@smap_server}#{@@actuation_api}", act )}
  	# devices = 
  end

def post2(url, query)
		uri = URI(url);
		
		req = Net::HTTP::Post.new(uri)
		post_body = [query.to_json]
		req.body = post_body.join
		req.content_type = 'application/json; charset=utf-8'

		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
		  http.request(req)
		end
		
		return req.body
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
