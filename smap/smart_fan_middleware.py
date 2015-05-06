import os
import socket
import msgpack
import uuid
import time
import requests
import json

# This is what we are listening on for messages
UDP_IP = "::" #all IPs
UDP_PORT = 1236

# Note we are creating an INET6 (IPv6) socket
sock = socket.socket(socket.AF_INET6,
    socket.SOCK_DGRAM)
sock.bind((UDP_IP, UDP_PORT))


data, addr = sock.recvfrom(1024)
msg = msgpack.unpackb(data)

smap = {
  "/smartfan" : {
    "Metadata" : {
      "SourceName" : "Smart Fan",
      "Location" : { "City" : "Berkeley" }
    },
    "Properties": {
      "Timezone": "America/Los_Angeles",
      "UnitofTime": "s",
      "UnitofMeasure": "Watt",
      "ReadingType": "double",  
      "Fan State": 
    },
    "Readings" : [[1351043674000, 0], [1351043675000, 1]],
    "uuid" : "119128be-e78a-11e4-8a00-1681e6b88ec1"
  }
}
while True:
    try: 
        data, addr = sock.recvfrom(1024)
        msg = msgpack.unpackb(data)
        val = float(msg)
        smap['/smartfan']['Readings'] = [[int(time.time()), val]]
        print smap
        x = requests.post('http://54.215.11.207:8079/add/fanstate', data = json.dumps(smap))
    except Exception as e:
       print e
~                  







