#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR
echo "Updating to latest versiom..."
git pull && git submodule init && git submodule update
chmod +x hecta
#cd twinpipe && make
#echo "You might need to install twinpipe. To do that, just cd to ./twinpipe, and run make install as root."
#cd ..
#cp twinpipe/twinpipe twinpipe/usleep .

echo "Done! You should be good to go now, if you have Lua, screen, and either LuaSocket or netcat."