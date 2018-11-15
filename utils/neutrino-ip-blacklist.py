#!/usr/bin/env python
#

# source: https://isc.sans.edu/forums/diary/Using+the+Neutrino+ipblocklist+API+to+test+general+badness+of+an+IP/24302/

import sys, getopt, argparse, requests, json
import urllib, urllib2
import time

def ipblocklist_host(ip):

   NEUTRINO_URL = 'https://neutrinoapi.com/ip-blocklist'
   NEUTRINO_USERID = '<YOUR-NEUTRINO-USERID>'
   NEUTRINO_API_KEY = '<YOUR-NEUTRINO-API-KEY>'

   NEUTRINO_PARAMS = {
      'user-id': NEUTRINO_USERID,
      'api_key': NEUTRINO_API_KEY,
      'ip': ip
   }

   req = urllib2.Request(NEUTRINO_URL, urllib.urlencode(NEUTRINO_PARAMS))
   response = urllib2.urlopen(req)
   result = json.loads(response.read())

   print "\n\nNeutrino Blocklist Service\n"
   print "IP: ", result['ip']
   print "On Blocklist: ", result['is-listed']
   print "Number of Blocklists: ", result['list-count']
   print "Last Seen: ", time.strftime('%Y-%m-%d %H:%M:%S', time.gmtime(result['last-seen']))
   print "Proxy: ", result['is-proxy']
   print "Tor: ", result['is-tor']
   print "VPN: ", result['is-vpn']
   print "Malware: ", result['is-malware']
   print "Spyware: ", result['is-spyware']
   print "Dshield: ", result['is-dshield']
   print "Hijacked: ", result['is-hijacked']
   print "Spider: ", result['is-spider']
   print "Bot: ", result['is-bot']
   print "SpamBot: ", result['is-spam-bot']
   print "ExploitBot: ", result['is-exploit-bot']
   if result['list-count'] > 0:
      print "List of Blocklists: \n", result['blocklists']

   return;

def main():

   parser = argparse.ArgumentParser()
   parser.add_argument('IP', help="IP address")
   args=parser.parse_args()

   ipblocklist_host(args.IP)

main()   # invoke main
