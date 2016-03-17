#!/bin/bash
    
# set document root
if [ -d "public" ]; then
    app_root=/public
elif [ -d "www" ]; then
    app_root=/www
elif [ -d "php" ]; then
    app_root=/php
fi
sed -i "s#/var/www#/var/www$app_root#g" /etc/apache2/sites-enabled/000-default.conf  

# run composer
if [ -f "composer.json" ]; then
    composer install
fi

# .htaccess found - enable AllowOverride (reduces apache performance)
if [ -f "/app$app_root/.htaccess" ]; then
    sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf
    sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/sites-enabled/000-default.conf 
    a2enmod rewrite
fi

if ([ -f "package.json" ] || [ -f "bower.json" ] || [ -f "Gruntfile.js" ]); then
    apt-get install -yq nodejs npm
    ln -s /usr/bin/nodejs /usr/bin/node
fi

if [ -f "package.json" ]; then
    npm install
fi

if [ -f "bower.json" ]; then
    npm install -g bower
    bower
fi

if [ -f "Gruntfile.js" ]; then
    npm install -g grunt-cli
    grunt
fi
