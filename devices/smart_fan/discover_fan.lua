require "cord"
require "storm" 
require "svcd"


SVCD.init(nil,function()
    print("listener init")
end)

counter=0
storm.os.invokePeriodically(3*storm.os.SECOND,function()
    print "going to write"
    counter=counter+1
    msg=""
    if counter%4==0 then
        msg="off"
    elseif counter%4==1 then
        msg="low"
    elseif counter%4==2 then
        msg="med"
    else
        msg="high"
    end	
    SVCD.write("fe80::212:6d02:0:3035",0x3009,0x4012,storm.mp.pack(msg),5000,function()
            print "I wrote things"
        end)
    end)

cord.enter_loop()
