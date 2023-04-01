#!/bin/bash

su - minecraft -c "
  git clone https://github.com/jesseflikweert/minecraft-server.git /home/minecraft

  cd ~/tools && git clone https://github.com/Tiiffi/mcrcon.git

  cd ~/tools/mcrcon

  gcc -std=gnu11 -pedantic -Wall -Wextra -O2 -s -o mcrcon mcrcon.c

  ./mcrcon -h
"
