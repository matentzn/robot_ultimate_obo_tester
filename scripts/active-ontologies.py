import requests
import yaml
import urllib.request
with urllib.request.urlopen("http://obofoundry.org/registry/ontologies.yml") as data:
    obo_data = yaml.safe_load(data)
    
for o in obo_data['ontologies']:
    oid = o['id']
    if o['activity_status']=="active":
            print(f"{oid}")
