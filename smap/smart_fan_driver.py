from smap import driver, actuate
from smap.util import periodicSequentialCall

import threading
import importlib

class SmartFan(driver.SmapDriver):
    def setup(self, opts):
        self.state = {'off': 0,
		      'low': 1, 
		      'medium': 2, 
		      'high': 3}
        self.readperiod = float(opts.get('ReadPeriod', .5))
        fan_state = self.add_timeseries('/fan_state', 'state', data_type='long')

        self.set_metadata('/', {'Metadata/Device': 'Fan Controller',
                                'Metadata/Model': 'Smart Fan',
                                'Metadata/Driver': __name__})

        archiver = opts.get('archiver')
	fan_state.add_actuator(StateActuator(tstat = self, 
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
        for k,v in self.state.iteritems():
            self.add('/'+k, v)

class SmartFanActuator(actuate.SmapActuator):
    def __init__(self, **opts):
        self.light = opts.get('fan')
        actuate.SmapActuator.__init__(self, opts.get('archiver'))
        self.subscribe(opts.get('subscribe'))


class StateActuator(SmartFanActuator, actuate.NStateActuator):

    def __init__(self, **opts):
        actuate.NStateActuator.__init__(self, opts['states'])
        SmartFanActuator.__init__(self, **opts)

    def get_state(self, request):
        return self.tstat.state[self.path]
    
    def set_state(self, request, state):
        self.tstat.state[self.path] = int(state)
        return self.tstat.state[self.path]

