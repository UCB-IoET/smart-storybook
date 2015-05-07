require "cord" -- scheduler
require("storm")
ipaddr = storm.os.getipaddr()

print("ip addr", ipaddrs)
print("node id", storm.os.nodeid())

pub_port = 9
priv_port = 50000
count = 0
