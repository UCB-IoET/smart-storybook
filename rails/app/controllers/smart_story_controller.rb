require 'net/http'

class SmartStoryController < ApplicationController
	before_action :authenticate_user!, :only => :composer
	time = Time.new
	log_file = File.open('log.txt', 'a')
	def register
		log_file.write("register accessed " + time.inspect)
		data_hash = uuid_modality_pairize
		render :json => data_hash
		# if params.has_key?("uuid") and params.has_key?("modalities")
			# file = File.read(@@devices_file)
			# data_hash = JSON.parse(file) rescue {}
			# if data_hash.has_key?(params[:uuid])
			# 	data_hash[params[:uuid]] = params[:modalities]
			# else
			# 	data_hash[params[:uuid]] = params[:modalities]
			# 	File.open('devices.json', 'w') do |f|
			# 		f.write(JSON.pretty_generate(data_hash))
			# 	end
			# end
		# else
		# 	error_msg = "Register function. This function needs to have a uuid and modalities fields."
		# 	render :json => error_msg.to_json
		# 	File.open('failures.txt', 'a') do |f|
		# 		f.write("register failed.")
		# 	end
		# end
	end

	def uuid_modality_pairize
		devices = {}
		IotDevice.all.each do |e|
			devices[e.uuid] = e.metadata
		end
		return devices
	end

	def echo
		@request = Request.new({response: params["data"].to_json.to_s})
		@request.save
	    @requests = Request.all.reverse[1..2]
		# render :json => params
	end

		
	
	# generate based on nearby devices, segments with desired environment
	def new_story
		# heat, air, light, smell, taste
		# 0 - 100

		#storybook's uuid, list of nearby devices, list of {page_number: {heat: 1, air:20}}
		
		log_file.write("new_story accessed " + time.inspect)

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
                #file = File.read('devices.json')
                #devices_hash = JSON.parse(file)
				devices_hash = uuid_modality_pairize
                nearby = params[:nearby_devices]
                devices = Hash.new
                nearby.each |index, uuid| do
                        devices[uuid] = devices_hash[uuid]
                end
                params[:pages].each |page, des_attrs| do
                        least = Hash.new
                        improved = true
                        pool = Hash.new
                        level = 1
                        devices.each |uuid, info| do
                        		info[:modalities].each |state, attrs| do
	                                ls = least_squares(des_attrs, attrs)
	                                closest = ls
	                                if ls == 0 
	                                        return attrs
	                                else 
	                                        pool[Hash[uuid, state]] = Hash["least_squares", ls, "attrs", attrs] #
	                                end
	                            end
                        end
                        while level < nearby.length and improved
                                improved = false
                                pool.each |uuids, prev_info| do
                                        this_improved = false
                                        if uuids.length == level
                                                nearby.each |uuid, info| do
                                                		info[:modalities].each |state, attrs| do
	                                                        new_attrs = sum_attrs(attrs, prev_info[:attrs])
	                                                        new_ls = least_squares(new_attrs, desired)
	                                                        if new_ls < prev_info[:least_squares]
	                                                                improved = true
	                                                                this_improved = true
	                                                                pool[uuids.merge({uuid, state})] = {"least_squares", new_ls, "attrs", new_attrs}
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
                        pool.each |uuids, info| do
                                if info[:least_squares] < closest
                                        closest = info[:least_squares]
                                        closest_uuids = uuids
                                end
                        end
                        env_hash[page] = Array.new
                        closest_uuids.each |uuid, state| do
                        	env_hash[page].push({"uuid", uuid, "state", state})
                        end

                end
                return env_hash
        end

	def least_squares(desired, given)
		ls = 0
		desired.each |attr, value| do
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
		log_file.write("advance_story accessed " + time.inspect)
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
end
