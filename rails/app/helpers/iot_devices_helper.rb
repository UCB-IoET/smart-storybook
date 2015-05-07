module IotDevicesHelper
def time_diff(start_time, end_time)
	# start_time = Time.now
	# end_time = Time.now + 1.hour

	seconds_diff = (start_time - end_time).to_i.abs

	hours = seconds_diff / 3600
	seconds_diff -= hours * 3600

	minutes = seconds_diff / 60
	seconds_diff -= minutes * 60

	seconds = seconds_diff
	# "Start: #{start_time}, End: #{end_time}
    "#{hours.to_s.rjust(2, '0')}h #{minutes.to_s.rjust(2, '0')}m #{seconds.to_s.rjust(2, '0')}s ago" 
end
end
