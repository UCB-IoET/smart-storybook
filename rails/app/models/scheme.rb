class Scheme < ActiveRecord::Base
	def self.get_sequence_hash
		sequence_hash = {}
		sequences = Sequence.all
		sequences.each do |sequence|
			behaviors = Sequence.find(sequence).behaviors
			behavior_hash = {}
			behaviors.each do |behavior|
				behavior_hash[behavior.name] = behavior.states
			end
			sequence_hash[sequence.name] = behavior_hash
		end
		sequence_hash
	end
end
