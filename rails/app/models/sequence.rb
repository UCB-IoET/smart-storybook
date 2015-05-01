require 'json'

class Sequence < ActiveRecord::Base
	has_many :behavior_links, dependent: :destroy
	has_many :behaviors, through: :behavior_links

	validates :name, presence: true
	validates_uniqueness_of :name
	validates :behaviors, presence: true

	def set_behaviors_from_names(name_array)
		@behaviors.each_with_index do |name, index|
			BehaviorLink.new({
				:sequence_id => self.name,
				:behavior_id => name,
				:order => index
			}).save
		end
	end

	def self.json_to_cpp(json_data)
		# return json_data
		name = json_data["sequence"]["name"]
		raw_values = json_data["sequence"]["states"]
		values = [];
		raw_values.each do |k, v|
			v.each do |e|
				values.push e.to_f
			end
		end
		self.array2cpp(name, values);
	end

	private

		def self.array2cpp(name, values, duration=1)
			self.generate_arduino_code(name, values, duration)
		end

		def self.generate_arduino_code(name, values, duration=1)
			File.open(name + "_seq.h", 'w') do |file| 
				values = clean_values(values)
				values = optimize_commands(values, duration)

				# convert to hex code
				values.map!{ |v, d| ["0x%02x" % v, d]; }
				
				# GENERATE ARDUINO CPP HEADER FILE
					last = values.pop
					header(name, file)
					file.write "blinkm_script_line #{name}[] = {\n"
					values.each do |v, d|
						file.write "{ #{d}, { 'n', #{hexify(v)}}},\n"
					end
					file.write "	{ #{last[1]}, { 'n', #{hexify(last[0])}}}\n"
					file.write "};\n"
					file.write "int script_#{name.downcase}_len = #{values.length};  // number of script lines above\n"
					footer(name, file);
				# END HEADER FILE
			end
			return IO.read(name + "_seq.h")
		end

		def self.unparseName b
			"/seq/SEQ_#{b}.svg"
		end

		def self.parseName b
			b.split('/seq/SEQ_')[1].split('.')[0]
		end

		def self.hexify(v)
			[v,v,v].join(',')
		end

		# takes in a values array of uint8 and output tuple array #[[value, duration]]
		# duration is a scaling factor - use 1
		def self.optimize_commands(values, duration)
			start = values.length
			last_value = values[0];
			time_since_switch = 0;
			values = values.each_with_index.collect do |v,i|
				v = v.to_i
				uniqueness = last_value != v
				last_value = uniqueness ? v : last_value
				
				# if last element, output value and duration 
				if i == values.length - 1
					r = [last_value, (time_since_switch + 1) * duration]
					time_since_switch = 0
					r
				else
					# skip repeated values
					if !uniqueness 
						time_since_switch = time_since_switch + 1
						next
					else
						r = [last_value, (time_since_switch + 1) * duration]
						time_since_switch = 0
						r
					end
				end
			end
			# SPARSIFY
			values.compact!
			
			# CALCULATE COMPRESSION
				# optimized = values.length
				# p "Start-End: #{start}-#{optimized} // #{"%0.2f" % ((start - optimized).to_f / start)} %"
			return values
		end

		def self.clean_values values
			# normalize to [0,1] float array
			min = values.min
			values.map!{ |v| (v - min)}
			max = values.max
			values.map!{ |v| max != 0 ? v / max : 1}

			# convert to uint8 array
			values.map!{ |v| (v * 255) }
			values
		end

		def self.header (name, file)
			file.write "//\n"
			file.write "//  #{name}_seq.h\n"
			file.write "//  Flixels - #{name} Light Sequence\n"
			file.write "//\n"
			file.write "//  Created by Cesar Torres on 7/2/14.\n"
			file.write "//  Copyright (c) 2014 Cesar Torres. All rights reserved.\n"
			file.write "//\n"
			file.write "\n"
			file.write "#ifndef __#{name}__flixel__\n"
			file.write "#define __#{name}__flixel__\n"
			file.write "\n"
			file.write "#include \"BlinkM_funcs.h\"\n"
		end

		def self.footer(name, file)
			file.write "#endif /* defined(__#{name}__flixel__) */"
		end

end