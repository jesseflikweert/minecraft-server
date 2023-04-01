#!/bin/bash

echo 'Container id:'
read container_id

echo 'Container password:'
read -s container_password

read -p "Do you agree to the Minecraft EULA (https://www.minecraft.net/en-us/eula)? (Y/n)" answer

if [ "$answer" != "Y" ]; then
  echo "Script terminated."
  exit 1
fi

function exco {
  command_to_execute="$1"
  pct exec "$container_id" -- bash -c "$command_to_execute"
}

echo "Creating container $container_id..."

# download the latest Debian template
pveam update
pveam download local debian-11-standard_11.6-1_amd64.tar.zst

# create a new LXC container with the specified ID and password
pct create $container_id local:vztmpl/debian-11-standard_11.6-1_amd64.tar.zst --hostname debian-minecraft --storage local-lvm --rootfs 100 --cores 4 --memory 6144 --net0 name=eth0,bridge=vmbr0,ip=dhcp --password $container_password --unprivileged --features nesting=1,keyctl=1 --onboot 1

# check if the container was created successfully
if [ $? -ne 0 ]; then
    echo "Error: Failed to create container $container_id"
    exit 1
fi

# start the container
pct start $container_id

# set up resolv.conf
exco "echo 'nameserver 8.8.8.8' > /etc/resolv.conf"

# update the packages inside the container
exco "apt-get update"
exco "apt-get upgrade -y"

# install required packages inside the container
exco "apt-get install -y nano git build-essential openjdk-17-jre-headless"

exco "useradd -r -m -U -d /home/minecraft -s /bin/bash minecraft"

# initialise server
#exco "$(wget -qLO - https://raw.githubusercontent.com/jesseflikweert/minecraft-server/main/initialise-server.sh)"
exco "wget -q https://raw.githubusercontent.com/jesseflikweert/minecraft-server/main/initialise-server.sh -O /tmp/initialise-server.sh && bash /tmp/initialise-server.sh"