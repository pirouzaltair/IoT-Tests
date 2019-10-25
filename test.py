  
import os

# start in the directory this script is run from
folder = 'collections'
extension = '.json'

os.system('npm install -g npm')
os.system('npm install -g newman')
os.system('npm install -g newman-reporter-html')
os.system('npm install -g newman-reporter-htmlextra')
cmd = 'newman run collections/UsageDataAPIlargedateranges.postman_collection.json  -e environments/IoTFullTest.postman_environment.json -r htmlextra --reporter-htmlextra-logs'.format(file)
os.system(cmd)
print 'done!'
