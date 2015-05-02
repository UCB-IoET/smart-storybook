class SmartStoryController < ApplicationController
	def register
		if params.has_key?("uuid") and params.has_key?("modalities")
			file = File.read('devices.json')
			data_hash = JSON.parse(file)
			if data_hash.has_key?(params[:uuid])
				data_hash[params[:uuid]] = params[:modalities]
			else
				data_hash[params[:uuid]] = params[:modalities]
				File.open('devices.json', 'w') do |f|
					f.write(JSON.pretty_generate(data_hash))
				end
			end
		else
			error_msg = "Register function. This function needs to have a uuid and modalities fields."
			render :json => error_msg.to_json
		end
	end

	def echo
		@request = Request.new({response: "IP: #{request.ip} T: #{Time.now.strftime("%I:%M %p")} P: #{params} "})
		@request.save
	    @requests = Request.all.reverse
		# render :json => params
	end
	
	# generate based on nearby devices, segments with desired environment
	def new_story
		if params.has_key?("uuid") and params.has_key?("nearby_devices") and params.has_key?("segments")
			env_hash = create_env(params)
			File.open('storyboard_environments/' + params[:uuid], 'w') do |f|
				f.write(JSON.pretty_generate(env_hash))
			end
		else
			error_msg = "New story. Push data to me by passing in your device's UUID, UUIDs of nearby devices and segment descriptions"
			render :json => error_msg.to_json
		end
	end
        def create_env(params)
                env_hash = Hash.new
                file = File.read('devices.json')
                devices_hash = JSON.parse(file)
                nearby = params[:nearby_devices]
                devices = Hash.new
                nearby.each {|index, uuid|
                        devices[uuid] = devices_hash[uuid]
                }
                params[:segments].each {|segment, attrs|
                        desired = params[segment]
                        least = Hash.new
                        improved = true
                        pool = Hash.new
                        level = 1
                        devices.each {|uuid, attrs| 
                                ls = least_squares(desired, attrs)
                                closest = ls
                                if ls == 0 
                                        return attrs 
                                else 
                                        pool[Hash[uuid, uuid]] = Hash["least_squares", ls, "attrs", attrs]
                                end
                        }
                        while level < nearby.length and improved
                                improved = false
                                pool.each { |uuids, prev_info|
                                        this_improved = false
                                        if uuids.length == level
                                                nearby.each { |uuid, attrs|
                                                        new_attrs = sum_attrs(attrs, prev_info[:attrs])
                                                        new_ls = least_squares(new_attrs, desired)
                                                        if new_ls < prev_info[:least_squares]
                                                                pool[]
                                                                improved = true
                                                                this_improved = true
                                                                pool[uuids.merge(Hash[uuid, uuid])] = Hash["least_squares", new_ls, "attrs", new_attrs]
                                                        end
                                                }
                                        end
                                        if this_improved
                                                pool.delete(uuids)
                                        end
                                }
                                level += 1
                        end
                        pool.each {|uuids, info|
                                if info[:least_squares] < closest
                                        closest = info[:least_squares]
                                        env_hash = uuids
                                end
                        }

                }
                return env_hash
        end

	def least_squares(desired, given)
		ls = 0
		desired.each {|attr, value|
			if given[attr] == nil
				given_value = 0
			else
				given_value = given[attr]
			end
			ls += (value - given_value)^2
		}
		return ls
	end
	def advance_story
		if params.has_key?("uuid") and params.has_key?("segment")
			file = File.read('storyboard_environments/' + params[:uuid])
			env_hash = JSON.parse(file)
			devices = env_hash[:segments][params[:segment]]
			devices.each { |uuid, val|
				#actuate uuid
			}
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
end
