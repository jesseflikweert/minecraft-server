#!/bin/bash

# get the container ID and password from the command-line arguments
container_id=$1
container_password=$2
mrcron_password=$3

if [ -z "$container_id" ] || [ -z "$container_password" ]  || [ -z "$mrcron_password" ]; then
    echo "Usage: $0 <container_id> <container_password> <mrcron_password>"
    exit 1
fi

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
pct exec $container_id -- bash -c "echo 'nameserver 8.8.8.8' > /etc/resolv.conf"

# update the packages inside the container
pct exec $container_id -- bash -c "apt-get update"
pct exec $container_id -- bash -c "apt-get upgrade -y"

# install required packages inside the container
pct exec $container_id -- bash -c "apt-get install -y nano"

# initialise server
pct exec $container_id -- bash -c "$(wget -qLO - https://raw.githubusercontent.com/jesseflikweert/minecraft-server/main/initialise-server.sh)"

