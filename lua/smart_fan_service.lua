require "cord"
require "storm" 
require "svcd"

storm.io.set_mode(storm.io.OUTPUT,  storm.io.D2)
storm.io.set_mode(storm.io.OUTPUT,  storm.io.D3)
storm.io.set_mode(storm.io.OUTPUT,  storm.io.D4)

function fanControl(state)
    storm.io.set(0, storm.io.D2)
    storm.io.set(0, storm.io.D3)
    storm.io.set(0, storm.io.D4)

	if state == "low" then 
		storm.io.set(1, storm.io.D2)
        print("turning on d2")
	end
	if state == "med" then 
		storm.io.set(1, storm.io.D3)
        print("turning on d3")
	end
	if state == "high" then 
		storm.io.set(1, storm.io.D4)
        print("turning on d4")
	end 	
end 

SVCD.init("Smart Fan",function() 
    print("this has been init") 
    SVCD.add_service(0x3009)
    SVCD.add_attribute(0x3009, 0x4012, function(pay, src_ip,src_port)
        print "setting fan speed"
        fanControl("low")
    end)
end)


cord.enter_loop()
