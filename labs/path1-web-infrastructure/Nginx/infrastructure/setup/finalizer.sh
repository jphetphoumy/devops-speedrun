#!/bin/bash

# Make verify script executable
chmod +x /usr/bin/verify

# Make sure permissions are set correctly for the /etc/nginx directory
chown -R :nginx_admin /etc/nginx
chmod 775 /etc/nginx
# Set permissions for the /etc/nginx/sites-available directory
chmod 774 /etc/nginx/sites-available
# Set permissions for the config files
chmod 664 /etc/nginx/sites-available/*.conf
# Set permissions for the sites-enabled directory
chmod 775 /etc/nginx/sites-enabled

# Enable all sites in sites-available
for site in /etc/nginx/sites-available/challenge*.conf; do
    ln -s "$site" /etc/nginx/sites-enabled/
done

# Set permission for /var/www 
chown -R www-data:www-data /var/www
chmod 750 /var/www/challenge3

# Restart Nginx to apply configurations
systemctl restart nginx

# Setup completed
touch /var/log/setup_complete

echo "The CTF Nginx web server setup is complete. ssh using admin@<ip> to access the server."
