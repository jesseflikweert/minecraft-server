#!/bin/bash

function rcon {
  /home/minecraft/minecraft-server/tools/mcrcon/mcrcon -H 127.0.0.1 -P 25575 -p YOURPASSWORD "$1"
}

rcon "save-off"
rcon "save-all"
tar -cvpzf /home/minecraft/minecraft-server/backups/server-$(date +%F-%H-%M).tar.gz /home/minecraft/minecraft-server/server
rcon "save-on"

## Delete older backups
find /home/minecraft/minecraft-server/backups/ -type f -mtime +7 -name '*.gz' -delete