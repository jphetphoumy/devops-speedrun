#!/bin/bash

# Do not allow user to ssh before the CTF setup is completed
cat >> ~/.bash_profile <<'EOFBASHPROFILE'
if [ ! -f /var/log/setup_complete ]; then
    echo "CTF setup is not complete. Please complete the setup before SSH access."
    exit 1
fi
EOFBASHPROFILE


cat > /etc/motd <<EOF
+==============================================================================+
|                           Welcome to the Apache CTF                          |
+==============================================================================+
| Target     : Apache Web Server                                               |
| Difficulty : Beginner                                                        |
| Objective  : Understand Vhost,                                               |
|              Fix broken configuration,                                       |
|              etc...,                                                         |
|              and capture the flag!                                           |
|                                                                              |
| Challenge:                                                                   |
| 0. To Understand how to play submit your first flag                          |
|    The flag is CTF{WELCOME_TO_APACHE_CTF}                                    |
|    Validate the first flag by running the following command:                 |
|      verify 0 CTF{WELCOME_TO_APACHE_CTF}                                     |
| 1. The goal of the first challenge is to understand                          |
|    the apache2 configuration to find the first flag.                         |
| 2. Create a new virtual host to find the next flag                           |
| 3. Have fun & learn something new                                            |
| 4. If you are stuck, use the GPT for help at                                 |
|    https://chatgpt.com/g/g-6838e2206e948191ac1fdaa4aa11b081-devops-speedrun  |
+==============================================================================+
| Hint: Start with http://<target-ip>                                          |
|       Good luck in your learning journey                                     |
+==============================================================================+

EOF


apt update
# Install necessary packages
apt install -y vim curl sudo 

# Setup apache2
apt install -y apache2 apache2-utils libapache2-mod-php php

# Copy authorized_keys to skel 
mkdir -p /etc/skel/.ssh
cp ~/.ssh/authorized_keys /etc/skel/.ssh/authorized_keys
# Set permissions for the authorized_keys file
chmod 600 /etc/skel/.ssh/authorized_keys
# Set permissions for the .ssh directory
chmod 700 /etc/skel/.ssh

# Configure sudo to allow the admin user to run the apache2 commands without a password
cat > /etc/sudoers.d/admin_apache <<EOF
# Allow admin user to run apache2 commands without a password
admin ALL=(ALL) NOPASSWD: /usr/bin/systemctl reload apache2
admin ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart apache2
admin ALL=(ALL) NOPASSWD: /usr/sbin/a2ensite *
admin ALL=(ALL) NOPASSWD: /usr/sbin/a2dissite *
admin ALL=(ALL) NOPASSWD: /usr/sbin/a2enmod *
admin ALL=(ALL) NOPASSWD: /usr/bin/vim /etc/hosts
EOF
# Set permissions for the sudoers file
chmod 440 /etc/sudoers.d/admin_apache

# Create the admin user
useradd -m -s /bin/bash admin
# Create apache_admin group
groupadd apache_admin
usermod -aG apache_admin admin
# Setup /etc/hosts
echo "127.0.0.1       challenge1.local" >> /etc/hosts
echo "127.0.0.1       challenge3.local" >> /etc/hosts
echo "127.0.0.1       challenge4.local" >> /etc/hosts
echo "127.0.0.1       challenge5.local" >> /etc/hosts