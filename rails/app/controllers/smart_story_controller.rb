require 'net/http'

class SmartStoryController < SmapController
	before_action :authenticate_user!, :only => :composer
	skip_before_filter  :verify_authenticity_token
	protect_from_forgery with: :null_session

	def uuid_modality_pairize
		devices = {}
		IotDevice.all.each do |e|
			devices[e.uuid] = e.metadata
		end
		return devices
	end

	def story_environment(story_id)
		data = Story.find(story_id).story_pages
		story_env = {}
		data = data.each do |s| 
			story_env[s.page_number.to_i] = {};
			s.story_modalities.each{|x| story_env[s.page_number.to_i][x.actuator.name.downcase]  = x.strength}
		end
		debug = []
		story_env = story_env.select{|s, v| not v.empty? }
		return story_env
	end


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

	def super_new_story
		story_id = 1
		
		if params["story_id"]
			story_id = params["story_id"].to_i			
		end

		story_env = story_environment(story_id)
		devices = uuid_modality_pairize()

		actions = {}
		devices.each do |uuid, info|
			info["modalities"].each do |action, characteristic|
				characteristic.each do |modality, strength|
					if not actions[modality] then actions[modality] = {} end
					if not actions[modality][strength] then actions[modality][strength] = [] end
					actions[modality][strength].append([uuid, action])
				end
			end
		end
		results = {}
		story_env.each do |page_number, modalities|
			modalities.each do |modality, strength|
				if not results[page_number] then results[page_number] = [] end
				valid = find_closest(actions, modality, strength)
				valid.each do |v|
					results[page_number].append(v)
				end
			end
		end
		debug = []

		StoryActuator.destroy_all
		results.each do |page, actuators|
			story_page = StoryPage.where("story_id = ? and page_number = ?", story_id, page).first;
			actuators = actuators.collect{|a| {uuid: a[0], state: a[1], story_page_id: story_page.id}}
			debug << StoryActuator.create(actuators)
		end
		# render :json => debug
		redirect_to stories_path, notice: 'A new story awaits...' 
	end
	
	# ACTUATION LOGIC GOES HERE
	def advance_story
		page_number = params["page_number"].to_i
		story_id = params["story_id"].to_i
		story_page = StoryPage.where("story_id = ? and page_number = ?", story_id, page_number).first;
		output = []
		# Thread.new do
			story_page.story_actuators.each do |a|
				state = a.state
				if a.state["value"] 
					state = a.state.split('_')[1].to_i
				end
				output << actuate_device(a.uuid, state)
				output << a.state
			end
		# end
		render :json => output
	end


	# DEBUG CODE
	def echo
		@request = Request.new({response: request.ip.to_s + params.to_json.to_s})
		@request.save
		@requests = Request.all.reverse[1..10]
		# render :json => params
	end
	
	# generate based on nearby devices, segments with desired environment

	def new_story
		story_id = 1
		story_env = story_environment(story_id)
		devices = uuid_modality_pairize()
		params = {uuid: story_id, pages: story_env, nearby_devices: devices}
		env_hash = create_env(params)
		render :json => env_hash
	end
	
	
	def composer
		@actuators = {}
		Actuator.all.each do |a|
			@actuators[a.id] = a
		end
		@actuators = @actuators.to_json

		@story = Story.find(params[:story_id])
		@page = @story.story_pages.find{|s| s.page_number == params[:page_number].to_i}
		
		@modalities = @page.story_modalities.map do |m|
			{id: m.id, actuator_id: m.actuator_id, url: m.actuator.picture_url, name: m.actuator.name, strength: m.strength}
		end
		previous_page = StoryPage.where("page_number = ?", @page.page_number - 1).first;
		@previous_modalities = {}

		if previous_page
			@previous_modalities = previous_page.story_modalities.map do |m|
				{id: m.id, actuator_id: m.actuator_id, url: m.actuator.picture_url, name: m.actuator.name, strength: m.strength}
			end
		end
		# render :json => previous_page
		render :layout => "singe_page_app"
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

	def create_env(params)
	    print "Creating a Whole New World\n"

		env_hash = Hash.new
		nearby = params[:nearby_devices]
		devices = params[:nearby_devices]

		print "DEVICES", devices, "\n"
		# TODO: FILTER NEARBY
		# devices_hash = uuid_modality_pairize
		# nearby = params[:nearby_devices]
		# devices = Hash.new
		# nearby.each do |index, uuid|
		# 	devices[uuid] = devices_hash[uuid]
		# end
		debug = []
		closest_uuids = []

		params[:pages].each do |page, des_attrs|
			least = Hash.new
			improved = true
			pool = {}
			level = 1
			closest = 0


			devices.each do |uuid, info|
				info["modalities"].each do |state, attrs|
					ls = least_squares(des_attrs, attrs)
					closest = ls
					if ls == 0 
						return {uuid => state}
					else 
						pool[{uuid => state}] = {:least_squares => ls, :attrs => attrs}
					end
				end
				print "INFO", info["modalities"], "\n"
			end
			print "POOL", pool, "\n"
			
			i = 0
			# while i < 1 and improved
			while level < nearby.length and improved
				print "Level", level, "\n"
				improved = false
				add_to_pool = {}
				pool.each do |uuids, prev_info|
					this_improved = false
					if uuids.length == level
						nearby.each do |uuid, info|
							info["modalities"].each do |state, attrs|
								# debug << sum_attrs(attrs, prev_info[:attrs])
								new_attrs = sum_attrs(attrs, prev_info[:attrs])
								new_ls = least_squares(new_attrs, des_attrs)
								print "NEW_LS", new_ls, "\n"
								if new_ls == 0
									return uuids.merge({uuid => state})
								end
								if new_ls < prev_info[:least_squares]
									improved = true
									this_improved = true
									add_to_pool[uuids.merge({uuid => state})] = {:least_squares => new_ls, :attrs => new_attrs}
								end
							end
						end
					end
					if this_improved
						pool.delete(uuids)
					end
				end
				add_to_pool.each{|k, v| pool[k] = v}
				level += 1
				i = i + 1
				print "Pool", pool, "\n"
				# debug << pool
			end

			
			pool.each do |uuids, info|
				if info[:least_squares] < closest
					closest = info[:least_squares]
					closest_uuids = uuids
				end
			end


			env_hash[page] = []
			closest_uuids.each do |uuid, state|
				env_hash[page].push({"uuid"=> uuid, "state"=> state})
			end

			# devices.each do |uuid, state|
			# 	env_hash[page].push({"uuid"=> uuid, "state"=> state})
			# end
			# debug << pool

		end
		print "FINAL RESULT", env_hash, "\n"
		return env_hash
	end
	def sum_attrs(curr, prev)
		result = {}
		curr.each{|k, v| result[k] = 0}
		prev.each{|k, v| result[k] = 0}

		curr.each{|k, v| result[k] += v}
		prev.each{|k, v| result[k] += v}
		return result
	end
	def least_squares(desired, given)
		print "Desired", desired, "  Given", given, "\n"
		ls = 0

		diff = {}
		# desired.each{|d| d.each }
		desired.each do |attr, value|
			if given[attr].nil?
				given_value = 0
			else
				given_value = given[attr]
			end
			ls += (value - given_value)**2
			print "LS: ", ls, "\n"
		end
		print "FINAL LS: ", ls, "\n"
		
		return ls
	end
	def find_closest(actions, modality, strength)
		if actions[modality]
			values = actions[modality].collect{|k, v| k }
			min = values.min_by { |v| (v.to_i - strength.to_i).abs } 
			return actions[modality][min]
		else
			return []
		end
	end

	def whatishappening
		story_id = 1
		story_env = story_environment(story_id)
		# devices = []
		devices = uuid_modality_pairize()
		params = {uuid: story_id, 
				  pages: story_env, 
				  nearby_devices: devices}

		render :json => params
	end
end
