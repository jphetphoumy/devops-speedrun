#!/bin/bash

# Make verify script executable
chmod +x /usr/bin/verify

# Make sure permissions are set correctly for the /etc/apache2 directory
chown -R :apache_admin /etc/apache2
chmod 775 /etc/apache2
# Set permissions for the /etc/apache2/sites-available directory
chmod 774 /etc/apache2/sites-available
# Set permissions for the /etc/apache2/conf-available files
chmod 664 /etc/apache2/sites-available/*.conf
# Set permissions for the /etc/apache2/conf-available directory
chmod 774 /etc/apache2/conf-available
# Set permissions for the /etc/apache2/sites-available files
chmod 664 /etc/apache2/conf-available/*.conf

# Set permission for /var/www 
chown -R www-data:www-data /var/www
chown 750 /var/www/challenge3

# Enable all challenge sites, and not the other sites
for conf in /etc/apache2/sites-available/challenge*.conf; do
    a2ensite "$(basename "$conf")"
done

# Reload Apache to apply changes
systemctl reload apache2
# Disable root access
#rm -f ~/.ssh/authorized_keys

# Setup completed
touch /var/log/setup_complete

echo "The CTF Apache web server setup is complete. ssh using admin@<ip> to access the server."