class Behavior < ActiveRecord::Base

	has_many :behavior_links, dependent: :destroy
	has_many :sequences, through: :behavior_links

	has_many :actuations, dependent: :destroy
	has_many :flavors, through: :actuations

	has_many :tags, dependent: :destroy
	has_many :experiments, dependent: :destroy

	def states
		if self[:states]
			self[:states].split(',').map{|x| x.to_f}
		else
			# foo
		end
	end

	def states=(_states)
		self[:states] = _states.join(',')
	end

	validates :name, presence: true
	validates_uniqueness_of :name
	validates :states, presence: true

	# number of top-category behaviors shown by filters
	SCORE_THRESHOLD = 5

	META_ATTRIBUTES = ["id", "created_at", "updated_at"]
	MAIN_ATTRS = self.attribute_names - META_ATTRIBUTES
	ARRAY_ATTRS = ["states"]
	STRING_ATTRS = ["name"]
	NUMBER_ATTRS = MAIN_ATTRS - ARRAY_ATTRS - STRING_ATTRS

	def self.get_main_attrs
		MAIN_ATTRS
	end

	def self.get_array_attrs
		ARRAY_ATTRS
	end

	def self.get_string_attrs
		STRING_ATTRS
	end

	def self.get_number_attrs
		NUMBER_ATTRS
	end

	def self.get_top_notification
		self._get_top_category "notification"
	end

	def self.get_top_active
		self._get_top_category "active"
	end

	def self.get_top_unable
		self._get_top_category "unable"
	end

	def self.get_top_low_energy
		self._get_top_category "low_energy"
	end

	def self.get_top_turning_on
		self._get_top_category "turning_on"
	end

	def self._get_top_category(category)
		self.order("#{category} DESC").limit(SCORE_THRESHOLD)
			.map{ |behavior| behavior.name }.to_json.html_safe
	end

	def self.get_smooths
		self.where("is_smooth", true).order("is_smooth DESC")
			.map{ |behavior| behavior.name }.to_json.html_safe
	end
	def metadata
		duration = self.states.length
		r = self.attributes.extract!("name", "id") 
		r["duration"] = duration;
		r["picture"] = "/wave.png";
		return r
	end
	# ouputs tuple array #[[time, value]]
	def sparse(alpha)
		states = self.states
		data = normalize(states).to_json
		cmd = "python bin/manifold/manifold.py compactwithalpha #{alpha} \"#{data}\""
		result = `#{cmd}`
		arr = JSON.parse(result)
		return arr
	end

	# normalizes values into an array of ints from 0 to 255
	def normalize values
		# normalize to [0,1] float array
		min = values.min
		values.map!{ |v| (v - min)}
		max = values.max
		values.map!{ |v| max != 0 ? v / max : 1}

		# convert to uint8 array
		values.map!{ |v| (v * 255) }
		values
	end
end
