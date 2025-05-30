#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

FLAG_HASHES=(
    "c77f9d6a6c81e7881f390398bd1cb050fcc94c0d311bea14f44b54accd3d3edd"  # Challenge 0
    "00f3dbfc8167e8d1a0634273519d6b930cce35b751a47cb3ae6a6b141728c947"  # Challenge 1
    "18f8729a7e2de9d2fb4f8f86405c8a17778868c8e60ac73c191e723d16d6241a"  # Challenge 2
    "32d59c9a29b2e9cb97c4577492cec7751ebeaa703c67fe5d0ef802ffa9e39270"  # Challenge 3
    "8e954ca50fb10e14c9c21c3e76ba01a501faa9265e0534009dc36c55d1d5ea37"  # Challenge 4
    "fdb6872955d7a75dd658ca5acef5e5568961d9c02cd76d7748f0e8069064b925"  # Challenge 5
    "d9533a5cf4c987aa8ece3ef3debe9464304f4a2232cf30b5dd52ef63f64d7517"  # Challenge 6
)

NEXT_LEVEL_CLUE=(
    "Nice job! You have completed the level 0 challenge. Now, to proceed to find the next flag, visit the web server url using your browser or the curl command."
    "Great work! You have completed the level 1 challenge.\nThere is a server block configured for the next challenge. Your goal is to access it by enabling this server block. Check the sites-available directory."
    "Awesome! Server blocks are not that complicated after all - level 2 done!\nNow, it's time for you to create your own server block.\nYou can do this by creating a new configuration file in /etc/nginx/sites-available/ \nand enabling it with a symbolic link to sites-enabled.\nOnce you have created your server block,\nyou can access it using the hostname you specified in the configuration file.\nMake a new server block that points to your next flag which is in /var/www/challenge3/index.html"
    "Great job! You have completed the level 3 challenge.\nNow, it's time to protect your server block with Basic Authentication.\nYou can do this by creating a .htpasswd file and configuring your server block to use it.\nOnce you have done this, you can access your server block using the username and password you specified in the .htpasswd file.\nYour goal is to setup Basic Auth for /var/www/challenge4, when done you will see the flag."
    "Excellent work! You have completed the level 4 challenge.\nNow, it's time to test your URL rewriting skills.\nYou need to create a rewrite rule that redirects /getflag to /index.php.\nOnce you have done this, you can access your server block using the /getflag URL.\nYour goal is to setup the rewrite rule for /var/www/challenge5/index.php, when done you will see the flag."
    "Well done! You have completed the level 5 challenge.\nNow, it's time to harden your Nginx configuration.\nYou need to set up a custom 404 error page and disable server tokens (version information).\nYou can do this by creating a custom 404.html file in /var/www/errors/ and configuring your server block to use it.\nYou also need to disable server tokens in the Nginx configuration file.\nOnce you have done this, you will have completed the final challenge."
)

validate_challenge_0() {
    local submitted_flag="$1"
    local flag_hash=$(echo -n "$submitted_flag" | sha256sum | cut -d' ' -f1)
    
    if [[ "$flag_hash" == "${FLAG_HASHES[0]}" ]]; then
        echo -e "${GREEN}Challenge 0 completed! Welcome to the lab!${NC}"
        echo -e "${NEXT_LEVEL_CLUE[0]}"
        echo "0 FLAG: $submitted_flag" >> ~/.completed_challenge
        return 0
    else
        echo -e "${RED}Incorrect flag. Try again.${NC}"
        return 1
    fi
}

validate_challenge_1() {
    local submitted_flag="$1"
    local flag_hash=$(echo -n "$submitted_flag" | sha256sum | cut -d' ' -f1)
    
    if [[ "$flag_hash" == "${FLAG_HASHES[1]}" ]]; then
        echo -e "${GREEN}Challenge 1 completed! You've successfully accessed the default web server.${NC}"
        echo -e "${NEXT_LEVEL_CLUE[1]}"
        echo "1 FLAG: $submitted_flag" >> ~/.completed_challenge
        return 0
    else
        echo -e "${RED}Incorrect flag. Make sure you can access the default web page.${NC}"
        return 1
    fi
}

validate_challenge_2() {
    local submitted_flag="$1"
    local flag_hash=$(echo -n "$submitted_flag" | sha256sum | cut -d' ' -f1)
    
    # Check if challenge2.conf is enabled
    if [ ! -f /etc/nginx/sites-enabled/challenge2.conf ]; then
        echo -e "${RED}Challenge 2 incomplete: The server block configuration is not enabled.${NC}"
        return 1
    fi
    
    if [[ "$flag_hash" == "${FLAG_HASHES[2]}" ]]; then
        echo -e "${GREEN}Challenge 2 completed! You've successfully discovered and configured the hidden server block.${NC}"
        return 0
    else
        echo -e "${RED}Incorrect flag. Make sure you can access the hidden server block.${NC}"
        return 1
    fi
}

validate_challenge_3() {
    local submitted_flag="$1"
    local flag_hash=$(echo -n "$submitted_flag" | sha256sum | cut -d' ' -f1)
    
    # Check if challenge3.conf exists and is enabled
    if [ ! -f /etc/nginx/sites-available/challenge3.conf ]; then
        echo -e "${RED}Challenge 3 incomplete: Server block configuration file does not exist.${NC}"
        return 1
    fi
    
    if [ ! -f /etc/nginx/sites-enabled/challenge3.conf ]; then
        echo -e "${RED}Challenge 3 incomplete: Server block configuration is not enabled.${NC}"
        return 1
    fi
    
    # Check if the document root is correctly set
    if ! grep -q "/var/www/challenge3" /etc/nginx/sites-available/challenge3.conf; then
        echo -e "${RED}Challenge 3 incomplete: Document root is not correctly set.${NC}"
        return 1
    fi
    
    if [[ "$flag_hash" == "${FLAG_HASHES[3]}" ]]; then
        echo -e "${GREEN}Challenge 3 completed! You've successfully created a new server block.${NC}"
        return 0
    else
        echo -e "${RED}Incorrect flag. Make sure your server block is properly configured.${NC}"
        return 1
    fi
}

validate_challenge_4() {
    local submitted_flag="$1"
    local flag_hash=$(echo -n "$submitted_flag" | sha256sum | cut -d' ' -f1)
    
    # Check if challenge4.conf exists and is enabled
    if [ ! -f /etc/nginx/sites-available/challenge4.conf ]; then
        echo -e "${RED}Challenge 4 incomplete: Server block configuration file does not exist.${NC}"
        return 1
    fi
    
    # Check if auth basic is configured
    if ! grep -q "auth_basic" /etc/nginx/sites-available/challenge4.conf; then
        echo -e "${RED}Challenge 4 incomplete: Basic authentication is not configured.${NC}"
        return 1
    fi
    
    # Check if auth basic user file is configured
    if ! grep -q "auth_basic_user_file" /etc/nginx/sites-available/challenge4.conf; then
        echo -e "${RED}Challenge 4 incomplete: Authentication user file is not configured.${NC}"
        return 1
    fi
    
    if [[ "$flag_hash" == "${FLAG_HASHES[4]}" ]]; then
        echo -e "${GREEN}Challenge 4 completed! You've successfully configured basic authentication.${NC}"
        return 0
    else
        echo -e "${RED}Incorrect flag. Make sure your basic authentication is properly configured.${NC}"
        return 1
    fi
}

validate_challenge_5() {
    local submitted_flag="$1"
    local flag_hash=$(echo -n "$submitted_flag" | sha256sum | cut -d' ' -f1)
    
    # Check if challenge5.conf exists
    if [ ! -f /etc/nginx/sites-available/challenge5.conf ]; then
        echo -e "${RED}Challenge 5 incomplete: Server block configuration file does not exist.${NC}"
        return 1
    fi
    
    # Check if rewrite rules are configured
    if ! grep -q "rewrite" /etc/nginx/sites-available/challenge5.conf; then
        echo -e "${RED}Challenge 5 incomplete: URL rewriting is not configured.${NC}"
        return 1
    fi
    
    if [[ "$flag_hash" == "${FLAG_HASHES[5]}" ]]; then
        echo -e "${GREEN}Challenge 5 completed! You've successfully configured URL rewriting.${NC}"
        return 0
    else
        echo -e "${RED}Incorrect flag. Make sure your URL rewriting is properly configured.${NC}"
        return 1
    fi
}

validate_challenge_6() {
    local submitted_flag="$1"
    local flag_hash=$(echo -n "$submitted_flag" | sha256sum | cut -d' ' -f1)
    
    # Check if challenge6.conf exists
    if [ ! -f /etc/nginx/sites-available/challenge6.conf ]; then
        echo -e "${RED}Challenge 6 incomplete: Server block configuration file does not exist.${NC}"
        return 1
    fi
    
    # Check if custom error page is configured
    if ! grep -q "error_page 404" /etc/nginx/sites-available/challenge6.conf; then
        echo -e "${RED}Challenge 6 incomplete: Custom error page is not configured.${NC}"
        return 1
    fi
    
    # Check if server tokens are turned off
    if ! grep -q "server_tokens off" /etc/nginx/nginx.conf; then
        echo -e "${RED}Challenge 6 incomplete: Server tokens are not disabled.${NC}"
        return 1
    fi
    
    if [[ "$flag_hash" == "${FLAG_HASHES[6]}" ]]; then
        echo -e "${GREEN}Challenge 6 completed! You've successfully hardened the Nginx server.${NC}"
        return 0
    else
        echo -e "${RED}Incorrect flag. Make sure your server hardening is properly configured.${NC}"
        return 1
    fi
}

show_progress() {
    local completed=0
 
    if [[ -f ~/.completed_challenge ]]; then
        completed=$(sort -u ~/.completed_challenge | wc -l)
    fi

    # Display what challenges have been completed
    echo "+-----------------------+"
    echo "| Challenges completed: |"
    echo "+-----------------------+"
    if [[ $completed -gt 0 ]]; then
        sort -u ~/.completed_challenge | while read -r challenge; do
            echo "Challenge_$challenge completed."
        done
    else
        echo "No challenges completed yet."
    fi
    echo "Progress: $completed/${#FLAG_HASHES[@]} challenges completed."
}

check_flag() {
    local challenge_num=$1
    local flag=$2

    if [[ -z "$challenge_num" || -z "$flag" ]]; then
        echo -e "${RED}Usage: $0 [challenge_num] [flag] - check the flag${NC}"
        return 1
    fi

    if [[ ! "$challenge_num" =~ ^[0-9]+$ ]] || (( challenge_num < 0 || challenge_num >= ${#FLAG_HASHES[@]} )); then
        echo -e "${RED}Invalid challenge number. Please provide a valid number.${NC}"
        return 1
    fi

    local expected_flag=${FLAG_HASHES[$challenge_num]}
    local provided_flag=$(echo -n "$flag" | sha256sum | cut -d' ' -f1)

    if [ "$provided_flag" = "$expected_flag" ]; then
        echo -e "${GREEN}Correct flag for challenge $challenge_num!${NC}"
        if [[ $challenge_num -lt $((${#FLAG_HASHES[@]} - 1)) ]]; then
            echo -e "${NEXT_LEVEL_CLUE[$challenge_num]}"
        else
            echo -e "${GREEN}Congratulations! You have completed all challenges.${NC}"
        fi
        echo "$challenge_num FLAG: $flag" >> ~/.completed_challenge
    else
        echo -e "${RED}Incorrect flag for challenge $challenge_num. Try again!${NC}"
    fi
}

# Check if challenge number is provided
if [[ $# -lt 1 ]]; then
    echo -e "${RED}Usage: $0 <challenge_number> [flag]${NC}"
    exit 1
fi

challenge_number="$1"
submitted_flag="$2"  # This may be empty for commands like "progress" or "hardening"

check_hardening() {
    local errors=0
    # Check for custom 404 error page
    CUSTOM_404=$(curl -s http://localhost/errors/404.html | grep -q "Custom 404 - Page Not Found")
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Custom 404 error page is set up correctly.${NC}"
    else
        echo -e "${RED}Custom 404 error page is not set up correctly. Please review your default error page configuration.${NC}"
        ((errors++))
    fi

    # Check if server tokens are disabled
    SERVER_TOKENS=$(grep -q "server_tokens off" /etc/nginx/nginx.conf)
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Server tokens are disabled.${NC}"
    else
        echo -e "${RED}Server tokens are not disabled. Make your server more secure by hiding version information.${NC}"
        ((errors++))
    fi
    
    # Check server tokens from response
    HIDE_INFO=$(curl -LIs http://localhost | grep -i "Server:" | awk '{print $2}' | tr -d '\r')
    if [ "$HIDE_INFO" = "nginx" ]; then
        echo -e "${GREEN}Well Done! This configuration avoids leaking version information.${NC}"
    else
        echo -e "${RED}Server is still showing version information. Make your server more secure.${NC}"
        ((errors++))
    fi

    if [ $errors -eq 0 ]; then
        echo -e "${GREEN}Hardening challenge completed successfully!${NC}"
        echo -e "${GREEN}Here's your flag: CTF{HARDENED_SERVER_MISSION_COMPLETE}${NC}"
        return 0
    else
        echo -e "${RED}$errors errors found. Please fix them to complete the hardening challenge.${NC}"
        return 1
    fi
}

case "$challenge_number" in
    "progress")
        show_progress
        ;;
    [0-9])
        if [[ "$challenge_number" =~ ^[0-9]+$ ]] && (( challenge_number >= 0 && challenge_number < ${#FLAG_HASHES[@]} )); then
            if [[ "$challenge_number" -eq 0 || "$challenge_number" -eq 1 ]]; then
                validate_challenge_$challenge_number "$submitted_flag"
            else
                check_flag "$challenge_number" "$submitted_flag"
            fi
        else
            echo -e "${RED}Invalid challenge number. Available challenges: 0-6${NC}"
            exit 1
        fi
        ;;
    "hardening")
        echo -e "Last challenge is the hardening challenge.\nYou need to harden the Nginx configuration by setting up a custom 404 error page and disabling server tokens (version information).\nYou can do this by creating a custom 404.html file in /var/www/html/errors/ and configuring your server block to use it.\nYou also need to disable server tokens in the Nginx configuration file."
        echo -e "Let me check your config and give you the last flag"
        check_hardening
        ;;
    *)
        echo -e "${RED}Usage: $0 <challenge_number> <flag> - check the flag${NC}"
        echo -e "${RED}Usage: $0 progress - Show the current progress${NC}"
        echo -e "${RED}Usage: $0 hardening - Show hardening challenge instructions${NC}" 
        exit 1
        ;;
esac

exit $?
