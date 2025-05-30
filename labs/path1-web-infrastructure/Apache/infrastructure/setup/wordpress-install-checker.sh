#!/bin/bash

# WordPress Installation Checker Script
# This script verifies that WordPress is properly installed and finalized,
# then creates a flag file readable by the admin user.

# Colors for better readability
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Starting WordPress installation check...${NC}"

# Define the expected WordPress installation path
WP_PATH="/var/www/wordpress"
FLAG_PATH="/home/admin/wordpress_flag"

# Check if WordPress directory exists
if [ ! -d "$WP_PATH" ]; then
    echo -e "${RED}FAIL:${NC} WordPress directory not found at $WP_PATH"
    exit 1
fi

# Check for critical WordPress files
echo -e "${YELLOW}Checking critical WordPress files...${NC}"
CRITICAL_FILES=("wp-config.php" "wp-login.php" "wp-content/themes" "wp-content/plugins" "wp-includes" "wp-admin")
MISSING_FILES=0

for file in "${CRITICAL_FILES[@]}"; do
    if [ ! -e "$WP_PATH/$file" ]; then
        echo -e "${RED}FAIL:${NC} Missing critical WordPress file: $file"
        MISSING_FILES=$((MISSING_FILES + 1))
    fi
done

if [ $MISSING_FILES -gt 0 ]; then
    echo -e "${RED}WordPress installation appears to be incomplete.${NC}"
    exit 1
fi

# Check wp-config.php for database configuration
if grep -q "DB_NAME" "$WP_PATH/wp-config.php" && grep -q "DB_USER" "$WP_PATH/wp-config.php"; then
    echo -e "${GREEN}SUCCESS:${NC} WordPress database configuration found"
else
    echo -e "${RED}FAIL:${NC} WordPress database configuration not set up properly"
    exit 1
fi

# Check if WordPress is accessible via HTTP (optional, needs curl)
if command -v curl &> /dev/null; then
    echo -e "${YELLOW}Checking WordPress HTTP response...${NC}"
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/wordpress/)
    
    if [[ "$HTTP_CODE" -eq 200 || "$HTTP_CODE" -eq 302 ]]; then
        echo -e "${GREEN}SUCCESS:${NC} WordPress site is responding with HTTP code $HTTP_CODE"
    else
        echo -e "${YELLOW}WARNING:${NC} WordPress site returned HTTP code $HTTP_CODE. It might not be fully set up"
    fi
fi

# Check file permissions
if [[ $(stat -c "%U" "$WP_PATH") == "www-data" ]]; then
    echo -e "${GREEN}SUCCESS:${NC} WordPress directory has correct owner"
else
    echo -e "${YELLOW}WARNING:${NC} WordPress directory owner is not www-data"
fi

# Final verification - check for specific WordPress tables in the database
if command -v mysql &> /dev/null; then
    echo -e "${YELLOW}Checking WordPress database tables...${NC}"
    
    # Attempt to get database credentials from wp-config.php
    DB_NAME=$(grep DB_NAME "$WP_PATH/wp-config.php" | cut -d \' -f 4)
    DB_USER=$(grep DB_USER "$WP_PATH/wp-config.php" | cut -d \' -f 4)
    DB_PASS=$(grep DB_PASSWORD "$WP_PATH/wp-config.php" | cut -d \' -f 4)
    
    if [ -n "$DB_NAME" ] && [ -n "$DB_USER" ] && [ -n "$DB_PASS" ]; then
        # Check for WordPress tables
        TABLES=$(mysql -u "$DB_USER" -p"$DB_PASS" -D "$DB_NAME" -e "SHOW TABLES LIKE 'wp_%';" 2>/dev/null)
        
        if [[ -n "$TABLES" ]]; then
            echo -e "${GREEN}SUCCESS:${NC} WordPress database tables found"
        else
            echo -e "${YELLOW}WARNING:${NC} No WordPress tables found in database"
        fi
    fi
fi

# Overall assessment
echo -e "${GREEN}WordPress appears to be installed correctly!${NC}"

# Create the flag file
echo "Creating WordPress flag file for admin..."
if [ ! -d "/home/admin" ]; then
    echo -e "${RED}FAIL:${NC} Admin home directory does not exist"
    exit 1
fi

# Generate a random flag
FLAG_CONTENT="CTF{WORDPRESS_MASTER}"

# Create the flag file with proper permissions
echo "$FLAG_CONTENT" > "$FLAG_PATH"
chown admin:admin "$FLAG_PATH"
chmod 400 "$FLAG_PATH"  # Only readable by owner (admin)

if [ -f "$FLAG_PATH" ]; then
    echo -e "${GREEN}SUCCESS:${NC} Flag file created at $FLAG_PATH"
    echo -e "Flag value: ${GREEN}$FLAG_CONTENT${NC}"
    exit 0
else
    echo -e "${RED}FAIL:${NC} Could not create flag file"
    exit 1
fi