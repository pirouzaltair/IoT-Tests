import os

# start in the directory this script is run from
folder = 'collections'
extension = '.json'

os.system('npm install -g npm')
os.system('npm install -g newman')
os.system('npm install -g newman-reporter-html')
os.system('npm install -g newman-reporter-htmlextra')

def files(path):
    for file in os.listdir(path):
        if os.path.isfile(os.path.join(path, file)):
        	if file.endswith(extension):
	            yield os.path.join(path, file)

for file in files(folder):
    # print 'processing {}'.format(file)
    # use quotes so the shell can handle spaces in filenames
    cmd = 'newman run "{}" -e environments/IoTFullTest.postman_environment.json -r htmlextra --reporter-htmlextra-logs'.format(file)
    os.system(cmd)
print 'done!'
