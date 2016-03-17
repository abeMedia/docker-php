#!/bin/bash

# Apache gets grumpy about PID files pre-existing
rm -f /var/run/apache2/apache2.pid

# set document root
if [ -d "public" ]; then
    app_root=/public
elif [ -d "www" ]; then
    app_root=/www
elif [ -d "php" ]; then
    app_root=/php
fi
app_root="/var/www$app_root"
sed -i "s#/var/www#$app_root#g" /etc/apache2/sites-enabled/000-default.conf

# .htaccess found - enable AllowOverride (reduces apache's performance)
if [ -f "$app_root/.htaccess" ]; then
    sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
    sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/sites-enabled/000-default.conf 
    a2enmod rewrite
fi

echo "Starting server..."
tail -F /var/log/apache2/* &
source /etc/apache2/envvars
exec apache2 -D FOREGROUND
