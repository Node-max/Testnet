#!/bin/bash

source <(curl -s https://raw.githubusercontent.com/R1M-NODES/utils/master/common.sh)

printLogo

read -p "Enter public SSH key: " PUBLIC_SSH_KEY
read -p "Enter new system username (default - admin) : " USERNAME
read -p "Enter space separated ports you want to expose for firewall (default - 22 9100 26656 26657): " PORTS
read -p "Enter wanted servername (default - unchanged): " HOSTNAME

USERNAME=${USERNAME:-'admin'}
PORTS=${PORTS:-'9100 26656 26657'}

if [[ -z $PUBLIC_SSH_KEY ]]; then
echo "Public key not provided" && sleep 1
exit 1
fi

printGreen "Upgrading system packages" && sleep 1

sudo apt update
sudo apt upgrade -y

printGreen "Creating new user: \"$USERNAME\" and configuring SSH" && sleep 1

sudo adduser $USERNAME --disabled-password -q
mkdir /home/$USERNAME/.ssh
echo $PUBLIC_SSH_KEY >> /home/$USERNAME/.ssh/authorized_keys
sudo chown $USERNAME: /home/$USERNAME/.ssh
sudo chown $USERNAME: /home/$USERNAME/.ssh/authorized_keys

echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

sudo sed -i 's/^PermitRootLogin\s.*$/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^ChallengeResponseAuthentication\s.*$/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#PasswordAuthentication\s.*$/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^#PermitEmptyPasswords\s.*$/PermitEmptyPasswords no/' /etc/ssh/sshd_config
sudo sed -i 's/^#PubkeyAuthentication\s.*$/PubkeyAuthentication yes/' /etc/ssh/sshd_config

sudo systemctl start sshd

printGreen "Installing fail2ban" && sleep 1

sudo apt install -y fail2ban

printGreen "Installing and configuring firewall" && sleep 1

sudo apt install -y ufw
sudo ufw default allow outgoing
sudo ufw default deny incoming
sudo ufw allow ssh
for port in ${PORTS// / }
do
    sudo ufw allow $port
done
sudo ufw enable

if [[ $HOSTNAME ]]; then
printGreen "Setting up new servername: \"$HOSTNAME\"" && sleep 1

sudo hostnamectl set-hostname $HOSTNAME
fi

printDelimiter

echo "Server setup is done." && sleep 1
echo "Now you can logout (exit) and login again using:" && sleep 1
printGreen "ssh $USERNAME@$(wget -qO- eth0.me)" && sleep 1
