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
|                           Welcome to the Nginx CTF                           |
+==============================================================================+
| Target     : Nginx Web Server                                                |
| Difficulty : Beginner                                                        |
| Objective  : Understand Server Blocks,                                       |
|              Fix broken configuration,                                       |
|              etc...,                                                         |
|              and capture the flag!                                           |
|                                                                              |
| Challenge:                                                                   |
| 0. To Understand how to play submit your first flag                          |
|    The flag is CTF{WELCOME_TO_NGINX_BASICS}                                  |
|    Validate the first flag by running the following command:                 |
|      verify 0 CTF{WELCOME_TO_NGINX_BASICS}                                   |
| 1. The goal of the first challenge is to understand                          |
|    the nginx configuration to find the first flag.                           |
| 2. Enable a hidden server block to find the next flag                        |
| 3. Have fun & learn something new                                            |
| 4. If you are stuck, use the GPT for help at                                 |
|    https://chatgpt.com/g/g-6838e2206e948191ac1fdaa4aa11b081-devops-speedrun  |
+==============================================================================+
| Hint: Start with http://<target-ip>                                          |
|       Good luck in your learning journey                                     |
+==============================================================================+

EOF

# Update packages
apt update
# Install necessary packages
apt install -y vim curl sudo nginx php-fpm

# Copy authorized_keys to skel 
mkdir -p /etc/skel/.ssh
cp ~/.ssh/authorized_keys /etc/skel/.ssh/authorized_keys
# Set permissions for the authorized_keys file
chmod 600 /etc/skel/.ssh/authorized_keys
# Set permissions for the .ssh directory
chmod 700 /etc/skel/.ssh

# Configure sudo to allow the admin user to run the nginx commands without a password
cat > /etc/sudoers.d/admin_nginx <<EOF
# Allow admin user to run nginx commands without a password
admin ALL=(ALL) NOPASSWD: /usr/bin/systemctl reload nginx
admin ALL=(ALL) NOPASSWD: /usr/bin/systemctl restart nginx
admin ALL=(ALL) NOPASSWD: /usr/bin/ln -s /etc/nginx/sites-available/* /etc/nginx/sites-enabled/*
admin ALL=(ALL) NOPASSWD: /usr/bin/rm -f /etc/nginx/sites-enabled/*
admin ALL=(ALL) NOPASSWD: /usr/bin/vim /etc/hosts
EOF
# Set permissions for the sudoers file
chmod 440 /etc/sudoers.d/admin_nginx

# Create the admin user
useradd -m -s /bin/bash admin
# Create nginx_admin group
groupadd nginx_admin
usermod -aG nginx_admin admin
# Setup /etc/hosts
echo "127.0.0.1       challenge1.local" >> /etc/hosts
echo "127.0.0.1       challenge3.local" >> /etc/hosts
echo "127.0.0.1       challenge4.local" >> /etc/hosts
echo "127.0.0.1       challenge5.local" >> /etc/hosts
