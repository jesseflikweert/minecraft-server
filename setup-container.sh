#!/bin/bash

# get the container ID and password from the command-line arguments
container_id=$1
password=$2

if [ -z "$container_id" ] || [ -z "$password" ]; then
    echo "Usage: $0 <container_id> <password>"
    exit 1
fi

echo "Creating container $container_id..."

# download the latest Debian template
pveam update
pveam download local debian-11-standard_11.6-1_amd64.tar.zst

# create a new LXC container with the specified ID and password
pct create $container_id local:vztmpl/debian-11-standard_11.6-1_amd64.tar.zst --hostname debian-minecraft --storage local-lvm --rootfs 20 --cores 4 --memory 6144 --net0 name=eth0,bridge=vmbr0,ip=dhcp --password $password --unprivileged --features nesting=1,keyctl=1 --onboot 1

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
pct exec $container_id -- bash -c "apt-get install -y nano openjdk-17-jre-headless git"

# clone the GitHub repository inside the container
pct exec $container_id -- bash -c "git clone https://github.com/jesseflikweert/minecraft-server.git /root/minecraft-server"

echo "Done."