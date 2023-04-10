#!/bin/bash

rcon_password = "$1";

su - minecraft -c "
  git clone https://github.com/jesseflikweert/minecraft-server.git ~/minecraft-server

  cd ~/minecraft-server/tools/mcrcon

  gcc -std=gnu11 -pedantic -Wall -Wextra -O2 -s -o mcrcon mcrcon.c

  ./mcrcon -h

  cd ~/minecraft-server/server

  echo 'eula=true' > eula.txt

  echo 'rcon.password=test123' >> server.properties

  chmod +x ./start.sh

  ./start.sh
"
