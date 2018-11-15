#!/usr/bin/env python

import os
import json

directory = "reports"

if not os.path.exists(directory):
    os.makedirs(directory)

p = os.popen('gsutil rsync gs://billing-reports/ reports/',"r")
while 1:
    line = p.readline()
    if not line: break
    print line

summ = float(0)

for filename in os.listdir(directory):

    if "production" in filename:
        billing = json.loads(open("reports/" + filename, "r").read())

        for item in billing:
            # now song is a dictionary
            for attribute, value in item.iteritems():
                if attribute == "cost":
                    summ += float(item['cost']['amount'])

                if attribute == "credits":
                    summ += float(item['credits'][0]['amount'])

production_sum = float(summ)

summ = float(0)

for filename in os.listdir(directory):

    if "stage" in filename:
        billing = json.loads(open("reports/" + filename, "r").read())

        for item in billing:
            for attribute, value in item.iteritems():
                if attribute == "cost":
                    summ += float(item['cost']['amount'])

                if attribute == "credits":
                    summ += float(item['credits'][0]['amount'])

stage_sum = float(summ)

print "GCP Total Cost: %.2f PRODUCTION: %.2f STAGE: %.2f" % ((float(production_sum) + float(stage_sum)),float(production_sum), float(stage_sum))
