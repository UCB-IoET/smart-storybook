class SmapController < ApplicationController
	@@smap_server =  "http://shell.storm.pm:8079";
	@@query_api = "/api/query"

  def manifest
  	@devices = get_devices("select *")
  end

  def get_status
	uuid = params["uuid"]
	if uuid.nil? 
		d = "Error, no UUID specified." 
	else 
		d = select_actuator(uuid)
		path = d["Path"]
		url = "/data#{path}"
	    resp = http_get(url)
	    if resp["error"].nil?
	    	resp = JSON.parse(resp)
	    	time = resp["Readings"][0][0]
	    	state = resp["Readings"][0][1]
	    	response = {time: Time.at(time/1000).strftime("%D %r"), state: state}
	    else
	    	response = "ERROR: Non-existent path"
	    end
	end
	# render :json => {response: resp}
	render :json => response
  end

  def select_actuator(uuid)
  	return get_devices("select * where uuid='#{uuid}'")[0];
  end

  #changing attributes
  def test
  	uuid = "25674a28-c05b-5bd1-940d-5c2790bfd919"
  	set_query = "set Path = '/buildinggeneral/plugstrip0/outlet4/on_act' where uuid = '#{uuid}'"
  	# smart_story_metadata = {:Modality => ["Light"], :Flavor => "Binary"}.to_json
  	# set_query = "set Metadata/SmartStoryBook = '#{smart_story_metadata}' where uuid = '#{uuid}'"
  	devices = http_post("#{@@smap_server}/api/query", set_query)
  	render :json => set_query
  end


  def to_smart_json
	  	devices = get_devices("select *")

	  	devices.collect! do |d|
	  		modalities = {}
	  		actions = []
	  		if not d["Metadata"]["SmartStoryBook"].nil?
	  			modality = JSON.parse(d["Metadata"]["SmartStoryBook"])["Modality"]

	  			model = d["Actuator"]["Model"]
	  			if model == "binary"
	  				states = d["Actuator"]["States"]
	  				states.map! do |s|
	  					modalities[s[1]] = {}
	  					modality.each do |m|
	  						m.downcase!
	  						modalities[s[1]][m] = s[0].to_i * 100
	  					end
	  					actions << s[1]

	  				end
	  				
	  			elsif model =="discrete"
	  				states = d["Actuator"]["Values"]
	  				states.map! do |s|
	  					s
	  				end
	  				modalities = states
	  			end

	  		end
	  		{
	  			:uuid => d["uuid"],
	  			:actuator_type => "SMAP",
	  			:metadata => {
		  			:name => (d["Metadata"]["Name"] or "No name"), 
			  		:modalities => modalities,
			  		:actions => actions
			  	}  
			}	
	 	end

	return devices
  end


  def actuate
  	uuid = params["uuid"]
  	state = params["state"]
	if uuid.nil? 
		resp = "Error, no UUID specified." 
	else 
	  	d = select_actuator(uuid)
		path = d["Path"]
		url = "/data#{path}?state=#{state}"
		resp = http_put(url)
  	end
  	render :json => resp
  end

  def get_devices(query)
  	devices = http_post("#{@@smap_server}#{@@query_api}", query)
  	devices = JSON.parse(devices);
  	# c["Metadata"]["Building"] == "IOET" and 
  			
  	devices.select! do |c| 
  		# if not c["Actuator"].nil? and (not c["Actuator"]["States"].nil?  or not c["Actuator"]["Values"].nil?) and c["Metadata"]  and not c["Metadata"]["Name"].nil? and not c["Metadata"]["Name"]["Thermostat"]  
  			c
  		# end 
  	end
  	return devices
  end


end
