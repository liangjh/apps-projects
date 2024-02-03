import http.server
import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('port', help='port on which to run file server', type=int)
parser.add_argument('directory', help='directory to serve files from', type=str)
args = parser.parse_args()

port = args.port
directory = args.directory

print('Running web / file server on port: {}, serving directory: {}'.format(port, directory))

os.chdir(directory)
server = http.server.ThreadingHTTPServer(('',port), http.server.SimpleHTTPRequestHandler)
server.serve_forever()

#
#  Execution Instructions: 
#  ----------------------------------------
#  python run_fileserver.py (port) (root-directory)
#  python run_fileserver.py 8081 /Users/liangjh/Workspace/tspire-api/data/images/generated/
# 
