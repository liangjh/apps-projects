#
#  Start Flask Server
#  TODO: is "run" the same on all servers

from app import app

app.run(host='0.0.0.0', port=8080, debug=True)



