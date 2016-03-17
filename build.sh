#!/bin/bash
    
# run composer
if [ -f "composer.json" ]; then
    composer install
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
