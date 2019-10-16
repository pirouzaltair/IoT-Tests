import os

# start in the directory this script is run from
folder = 'collections'
extension = '.json'

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
