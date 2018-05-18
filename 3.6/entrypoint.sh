#!/usr/bin/env bash

# Override this script with custom stuff if needed
/root/before_script.sh

# Start the server.
# The first config is defaults, the second is supposed to be provided by the app
/usr/local/bin/uwsgi --ini /root/uwsgi.ini --ini /app/uwsgi.ini
