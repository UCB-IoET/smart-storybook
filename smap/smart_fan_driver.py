import os
import socket
import msgpack
import json
import requests

from smap import driver, actuate
from smap.util import periodicSequentialCall

import threading
import importlib


class SmartFan(driver.SmapDriver):
    def setup(self, opts):
       # self.states = {'off': 0,
	#	      'low': 1, 
	#	      'medium': 2, 
	#	      'high': 3}
        
	# This is what we are listening on for messages
	self.UDP_IP = "2001:470:4956:2:212:6d02::3035" #all IPs
	self.UDP_PORT = 1236

	# Note we are creating an INET6 (IPv6) socket
	self.sock = socket.socket(socket.AF_INET6,
   		 socket.SOCK_DGRAM)
	#sock.bind((UDP_IP, UDP_PORT))

	print self
	self.currentFanState = 0
        self.readperiod = float(opts.get('ReadPeriod', .5))
        fan_state = self.add_timeseries('/fan_state', 'state', data_type='long')
	print fan_state
	print self
	print self.set_metadata
        self.set_metadata('/', {'Metadata/Device': 'Fan Controller',
                                'Metadata/Model': 'Smart Fan',
				'Metadata/SourceName' : "Smart Fan", 
				'Properties/Timezone' : "America/Los_Angeles", 
				'Properties/UnitofTime' : 's', 
				'Properties/UnitofMeasure': 'Watt', 
				'Properties/ReadingType': 'double', 
				'Metadata/Location/City':  "Berkeley", 
                                'Metadata/Driver': __name__})


        archiver = opts.get('archiver')
	fan_state.add_actuator(StateActuator(fan = self, 
					     states=[0,1,2,3],
					     archiver=archiver, 
					     subscribe=opts.get('on')))

        metadata_type = [
                ('/fan_state','Reading'),
                ('/fan_state_act','Command')
                ]
        for ts, tstype in metadata_type:
            self.set_metadata(ts,{'Metadata/Type':tstype})

    def start(self):
        periodicSequentialCall(self.read).start(self.readperiod)

    def read(self): 
	self.add('/fan_state', self.currentFanState)

class SmartFanActuator(actuate.SmapActuator):
    def __init__(self, **opts):
        self.fan = opts.get('fan')
	self.states = opts.get('states')
        actuate.SmapActuator.__init__(self, opts.get('archiver'))
        self.subscribe(opts.get('subscribe'))


class StateActuator(SmartFanActuator, actuate.NStateActuator):

    def __init__(self, **opts):
        actuate.NStateActuator.__init__(self, opts['states'])
        SmartFanActuator.__init__(self, **opts)

    def get_state(self, request):
        return self.fan.currentFanState
    
    def set_state(self, request, state):
        try: 
		self.fan.currentFanState = state
		print state, "BEFORE I SEND"
        	self.fan.sock.sendto(msgpack.packb(state), (self.fan.UDP_IP, self.fan.UDP_PORT))
       		print state, "AFTER I SEND"
       		return self.fan.currentFanState
	except Exception as e:
		print e
