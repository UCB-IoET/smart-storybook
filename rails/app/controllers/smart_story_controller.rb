require 'net/http'

class SmartStoryController < SmapController
	before_action :authenticate_user!, :only => :composer

	# SMAP registration of devices...
	def register
		IotDevice.where("actuator_type = ?", "SMAP").destroy_all

		devices = to_smart_json;
		devices.each do |d| 
			d[:metadata] = d[:metadata].to_json.html_safe 
			d[:last_seen] = Time.now
		end
		
		s = IotDevice.create(devices);
		redirect_to iot_devices_path, notice: 'SMAP devices where successfully registered.' 
	end




	def uuid_modality_pairize
		devices = {}
		IotDevice.all.each do |e|
			devices[e.uuid] = e.metadata
		end
		return devices
	end

	def echo
		@request = Request.new({response: request.ip.to_s + params.to_json.to_s})
		@request.save
		@requests = Request.all.reverse[1..10]
		# render :json => params
	end


	
	# generate based on nearby devices, segments with desired environment
	def new_story
		# heat, air, light, smell, taste
		# 0 - 100

		#storybook's uuid, list of nearby devices, list of {page_number: {heat: 1, air:20}}
		log("new_story accessed")
		if params.has_key?("uuid") and params.has_key?("nearby_devices") and params.has_key?("pages")
			env_hash = create_env(params)

			
			
			# {"output" {1: [{uuid: uuid1, state: "on"}, {uuid: uuid2, state: "off"}]}, 
			# 			4: [{uuid: uuid, state: state}]}


			# File.open('storyboard_environments/' + params[:uuid], 'w') do |f|
			# 	f.write(JSON.pretty_generate(env_hash))
			# end

			# ActuatorLabel()
		else
			error_msg = "New story. Push data to me by passing in your device's UUID, UUIDs of nearby devices and segment descriptions"
			render :json => error_msg.to_json
		end
	end
	def create_env(params)
		env_hash = Hash.new
		devices_hash = uuid_modality_pairize
		nearby = params[:nearby_devices]
		devices = Hash.new
		nearby.each do |index, uuid|
			devices[uuid] = devices_hash[uuid]
		end
		params[:pages].each do |page, des_attrs|
			least = Hash.new
			improved = true
			pool = Hash.new
			level = 1
			devices.each do |uuid, info|
				info[:modalities].each do |state, attrs|
					ls = least_squares(des_attrs, attrs)
					closest = ls
					if ls == 0 
						return attrs
					else 
						pool[{uuid => state}] = {"least_squares" => ls, "attrs" => attrs}
					end
				end
			end
			while level < nearby.length and improved
				improved = false
				pool.each do |uuids, prev_info|
					this_improved = false
					if uuids.length == level
						nearby.each do |uuid, info|
							info[:modalities].each do |state, attrs|
								new_attrs = sum_attrs(attrs, prev_info[:attrs])
								new_ls = least_squares(new_attrs, desired)
								if new_ls < prev_info[:least_squares]
									improved = true
									this_improved = true
									pool[uuids.merge({uuid => state})] = {"least_squares" => new_ls, "attrs" => new_attrs}
								end
							end
						end
					end
					if this_improved
						pool.delete(uuids)
					end
				end
				level += 1
			end
			pool.each do |uuids, info|
				if info[:least_squares] < closest
					closest = info[:least_squares]
					closest_uuids = uuids
				end
			end
			env_hash[page] = Array.new
			closest_uuids.each do |uuid, state|
				env_hash[page].push({"uuid"=> uuid, "state"=> state})
			end

		end
		return env_hash
	end

	def least_squares(desired, given)
		ls = 0
		desired.each do |attr, value|
			if given[attr].nil?
				given_value = 0
			else
				given_value = given[attr]
			end
			ls += (value - given_value)^2
		end
		return ls
	end
	def advance_story
		log("advance_story accessed")
		#data: [page
		if params.has_key?("uuid") and params.has_key?("pages")
			# file = File.read('storyboard_environments/' + params[:uuid])
			# env_hash = JSON.parse(file)
			# devices = env_hash[:segments][params[:segment]]
			

			# devices.each { |uuid, val|
				# if StoryActuator.protocol == "SVCD"
					# "SVCD Manifest"
					# ipv6, socket
				# elsif StoryActuator.protocol == "SMAP"
					# SMAPActuator.find(devices.uuid).actuate(state);
				# end

				#actuate uuid
			# }
		else
			error_msg = "Advance story to specified segment. Please supply your storyboard's UUID and the segment to advance to."
			render :json => error_msg.to_json
		end
	end
	
	def composer
		@story = Story.find(params[:story_id])
		@page = @story.story_pages.find{|s| s.page_number == params[:page_number].to_i}
		render :layout => "singe_page_app"
	end

	def actuator_list
	end

	def simulator
	end

	def documentation
	end

	def log(string)
		time = Time.new
		File.open('log.txt', 'a') do |f|
			f.puts(time.inspect + ": " + string)
		end
	end
end