import os, sys, getopt

# start in the directory this script is run from
folder = 'collections'
extension = '.json'

# os.system('npm install -g npm')
# os.system('npm install -g newman')
# os.system('npm install -g newman-reporter-html')
# os.system('npm install -g newman-reporter-htmlextra')

def menu():
    print("\033[3;37;40m====================================================================\t\t\033[0;37;40m")
    print("\033[5;31;40m\t\t\t\tOptions\t\t\t\t\t\t\033[0;37;40m")
    print("\033[3;37;40m====================================================================\t\t\033[0;37;40m")
    print("\033[1;36;40m-h     -hh\t\t<help menu>\t\t\t\t\t\t")
    print("\033[1;32;40m-l     --limit\t\t<quantity of desired reports per collection>\t\t")
    print("\033[1;36;40m-d     --days\t\t<max age of reports, in days>\t\t\t\t")
    print("\033[3;37;40m====================================================================\t\t\033[0;37;40m")
    print("\033[5;31;40m\t\t\t\tExample\t\t\t\t\t\t\033[0;37;40m")
    print("\033[1;36;40\t\tpython runCollections.py -l 1 -d 1\t\t\t\t")
    print("\033[3;37;40m====================================================================\t\t\033[0;37;40m")

def files(path):
    for file in os.listdir(path):
        if os.path.isfile(os.path.join(path, file)):
        	if file.endswith(extension):
	            yield os.path.join(path, file)

# for file in files(folder):
#     # print 'processing {}'.format(file)
#     # use quotes so the shell can handle spaces in filenames
#     cmd = 'newman run "{}" -e environments/IoTFullTest.postman_environment.json -r htmlextra --reporter-htmlextra-logs'.format(file)
#     os.system(cmd)

def main(argv):
    max_age = 0
    reports_per_collection = 0
    try:
        opts, args = getopt.getopt(sys.argv[1:], "hl:d:", ['help', 'limit=', 'days='])
    except getopt.GetoptError:
        print 'Error: improper options or arguments.'
        menu()
        sys.exit(2)

    for opt, arg in opts:
        if opt in ('-h', '--help'):
            menu()
            sys.exit(2)
        elif opt in ('-l', '--limit'):
            reports_per_collection = arg
        elif opt in ('-d', '--days'):
            max_age = arg
        else:
            print 'Error- must provide 2 arguments.'
            menu()
            sys.exit(2)

    for file in files(folder):
        # print 'processing {}'.format(file)
        # use quotes so the shell can handle spaces in filenames
        newman_cmd = '\n\nnewman run "{}" -e environments/IoTFullTest.postman_environment.json -r htmlextra --reporter-htmlextra-logs'.format(file)
        os.system(newman_cmd)

    file_manager_cmd = '\n\nsh fileManager.sh -l ' + reports_per_collection + ' -d ' + max_age
    os.system(file_manager_ccmd)
    sys.exit()

if __name__ == "__main__":
    main(sys.argv[1:])
    print 'done!'
