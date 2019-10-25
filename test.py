  
import os

# start in the directory this script is run from
folder = 'collections'
extension = '.json'

os.system('npm install -g npm')
os.system('npm install -g newman')
os.system('npm install -g newman-reporter-html')
os.system('npm install -g newman-reporter-htmlextra')



    # print 'processing {}'.format(file)
    # use quotes so the shell can handle spaces in filenames
    cmd = 'newman run -e environments/IoTFullTest.postman_environment.json collections/DeviceEventData.postman_collection.json -r htmlextra --reporter-htmlextra-logs'.format(file)
    os.system(cmd)

print 'done!'
