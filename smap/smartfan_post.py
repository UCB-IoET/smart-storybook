#!/usr/bin/env python

from operator import *
from sys import argv
from util import *
import json
import Queue
import thread
from util import load_json
from ws4py.client.threadedclient import WebSocketClient
import requests
import time




smap_query_url = "http://shell.storm.pm:8079/api/query"  
smap_actuation_url = "http://shell.storm.pm:8079/add/apikey"  
  


def smap_actuate(uuid, reading, q_url, a_url):
    q_url = q_url or smap_query_url
    a_url = a_url or smap_actuation_url
    #query the acutation stream for 'Properties'
    try:
        r = "select * where uuid = '{}'".format(uuid)
        resp = requests.post(q_url, r)
        j = load_json(resp.text)
        properties = j[0].get('Properties', {})
    except Exception as e:
        print "Error: smap_actuate --failed to extract 'propereties'"
        print e
        exit(1)

    #uuid of our stream
    #TODO: should we have a unique one for each thread?
    act_stream_uuid = "52edbddd-98e9-5cef-8cc9-9ddee810cd88"

    #construct our actuation request
    act = {'/actuate': {'uuid': act_stream_uuid,
                        'Readings': [[int(time.time()), reading]],
                        'Properties': properties,
                        'Metadata':{'override': uuid}}}

    print "sending smap actuation..."
    print requests.post(a_url, data=json.dumps(act))
#    print "sleeping for 3s"
#    time.sleep(3)



