module IotDevicesHelper
def time_diff(start_time, end_time)
  hours = end_time.hour - start_time.hour
  minutes = end_time.min - start_time.min
  seconds = end_time.sec - start_time.sec
  "#{hours.to_s.rjust(2, '0')}h #{minutes.to_s.rjust(2, '0')}m #{seconds.to_s.rjust(2, '0')} s ago" 
end
end
