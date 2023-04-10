# minecraft-server
The repository containing my Proxmox LXC Debian Minecraft server configuration, including some shell scripts.

# server jar file
The server's jar file is `paper-1.19.4-484.jar`.

# Steps
* Please setup the container using this command in the Proxmox node shell: `bash -c "$(wget -qLO - https://raw.githubusercontent.com/jesseflikweert/minecraft-server/main/setup-container.sh)"`
* Log into your container
* Execute `su - minecraft`
* Execute `cd ~/minecraft-server/server`
* Execute `bash ./start.sh`
* Stop the server (`ctrl+c`)
* Accept eula using `nano eula.txt`
* Using `nano server.properties`, set the properties `rcon.password=YOURPASSWORD` and `enable-rcon=true`
* Exit using `exit` to switch back to root.
* Initialize the systemctl file using `cp /home/minecraft/minecraft-server/tools/systemctl.template /etc/systemd/system/minecraft.service`
* Fill in the RCON password using `nano /etc/systemd/system/minecraft.service`
* Execute `systemctl start minecraft`
* Check status using `systemctl status minecraft`
* Enable start on startup using `systemctl enable minecraft`
* Switch back to minecraft using `su - minecraft && cd ~`
* Fill in the RCON password using `nano minecraft-server/tools/backup.sh`
* Make executeable using `chmod +x /home/minecraft/minecraft-server/tools/backup.sh`
* Make a crontab for it using `crontab -e`. Add the line `0 23 * * * /opt/minecraft/tools/backup.sh`
* Execute commands using `/home/minecraft/minecraft-server/tools/mcrcon/mcrcon -H 127.0.0.1 -P 25575 -p YOURPASSWORD -t`

# inspired by
https://www.shells.com/l/en-US/tutorial/0-A-Guide-to-Installing-a-Minecraft-Server-on-Linux-Ubuntu