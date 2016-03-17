#!/bin/bash

# Apache gets grumpy about PID files pre-existing
rm -f /var/run/apache2/apache2.pid

echo "Starting server..."

tail -F /var/log/apache2/* &

source /etc/apache2/envvars
exec apache2 -D FOREGROUND
