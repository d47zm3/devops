#!/usr/bin/python

import urllib2
import json
import requests
from bs4 import BeautifulSoup

rawjson = urllib2.urlopen("https://api.wordpress.org/core/version-check/1.7/").read()
version = json.loads(rawjson)
current_version = version["offers"][0]["version"]

url = 'https://blog.wordpress.com'
response = requests.get(url)
soup = BeautifulSoup(response.text, "html.parser")

metas = soup.find_all('meta')

live_version = [ meta.attrs['content'] for meta in metas if 'name' in meta.attrs and meta.attrs['name'] == 'generator' ]
line =  ''.join(live_version)

live_version =  line.split(' ')[2]

if current_version == live_version:
        print "Wordpress is updated!"
else:
        print "Wordpress needs an update!"
        print "Live version is %s and current version is %s" % ( live_version, current_version )
        exit(1)

url = 'https://custom-blog.wordpress.com'
response = requests.get(url)
soup = BeautifulSoup(response.text, "html.parser")

metas = soup.find_all('meta')

live_version = [ meta.attrs['content'] for meta in metas if 'name' in meta.attrs and meta.attrs['name'] == 'generator' ]
line =  ''.join(live_version)

live_version =  line.split(' ')[1]

if current_version == live_version:
        print "Wordpress is updated!"
        exit(0)
else:
        print "Wordpress needs an update!"
        print "Live version is %s and current version is %s" % ( live_version, current_version )
        exit(1)
