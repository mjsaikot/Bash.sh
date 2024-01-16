#Disable direct SSH root login on all app servers
# Question: Create group to all server and create user and add to group for all server.
#!/bin/bash
newuser="rajesh"
grp="nautilus_admin_users"
# List of servers
servers=("stapp01" "stapp02" "stapp03")

# Usernames for each server (in the same order as servers)
users=("tony" "steve" "banner")

# Command to run on each server with sudo
#sudo_command=“”
 

# SSH key generation
echo "Generating ssh key..."
ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
echo "SSH key generated."

# Loop through servers, copy the SSH key, and run commands
for ((i = 0; i < ${#servers[@]}; i++)); do
  server="${servers[$i]}"
  user="${users[$i]}"
  password="${passwords[$i]}"

  echo "Connecting to $user@$server..."

  # Copy SSH key using sshpass
  sshpass -p "$password" ssh-copy-id -o StrictHostKeyChecking=no "$user@$server"
  echo "SSH key copied to $server"

  # SSH and run the command with sudo
  ssh -t "$user@$server" "sudo useradd $newuser && sudo groupadd $grp && sudo usermod -a -G $grp $newuser"
  echo
  echo “Done in $server” 
  echo 
done