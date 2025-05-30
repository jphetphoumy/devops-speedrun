#!/bin/bash
# This script is used to verify the CTF environment
FLAGS=(
    "7dce804d92cc0f1c28008aa40a16aff4cedcba60833951cb342625fa04d0e51b"
    "e11c04d44d2bdba7fa736c4977470a87e25fd40c312b7ea0d4de00adb6414c4b"
    "2fd8c3789553ddc1a6aca3434c7e70349ac046928b7597885053519ecad3aac4"
    "14960f67a29878be0ae0600853478d5d757a60ac437acda04804ebf491bf50d3"
    "f018a5f223c772dd13fe3073f3644303aa9143aa48f5f73b1fb02c003f3151ee"
    "b463a2e1e7d6b38307c0247865af53976d4e503cd4a868f352e711196d97076f"
    "a106d453d709c136c4b9d6cc0f55679b39cd0ec6dcd465d872375b54b954d92b"
)

NEXT_LEVEL_CLUE=(
    "Nice job! You have completed the level 0 challenge. Now, to proceed to find the next flag, visit the web server url using your browser or the curl command."
    "Great work! You have completed the level 1 challenge.\nThere is a virtual host configured for the next challenge. Your goal is to access it, you can edit your /etc/hosts to add the hostname and ip\nOr you can use the Host header with curl. If you're stuck feel free ask the GPT for help"
    "Awesome! vhost are not that complicated after all level 2 done !\nNow, it's time for you to create your own virtual host.\nYou can do this by creating a new configuration file in /etc/apache2/sites-available/ \nand enabling it with a2ensite.\nOnce you have created your virtual host,\nyou can access it using the hostname you specified in the configuration file.\nMake a new virtual host that point to your next flag which is in /var/www/challenge3/index.html"
    "Great job! You have completed the level 3 challenge.\nNow, it's time to protect your virtual host with Basic Authentication.\nYou can do this by creating a .htpasswd file and configuring your virtual host to use it.\nOnce you have done this, you can access your virtual host using the username and password you specified in the .htpasswd file.\nYour goal is to setup Basic Auth for /var/www/challenge4, when done you will see the flag"
    "Excellent work! You have completed the level 4 challenge.\nNow, it's time to test your URL rewriting skills.\nYou need to create a rewrite rule that redirects /getflag to /flag.php.\nOnce you have done this, you can access your virtual host using the /getflag URL.\nYour goal is to setup the rewrite rule for /var/www/challenge5/index.php, when done you will see the flag"
    "Well done! You have completed the level 5 challenge.\nNow, it's time to harden your Apache configuration.\nYou need to set up a custom 404 error page and disable directory listing.\nYou can do this by creating a custom 404.html file in /var/www/html/errors/ and configuring your virtual host to use it.\nOnce you have done this, you can access your virtual host and see the custom 404 error page.\nYou also need to disable version information in the Apache configuration.\nYou can do this by setting ServerTokens and ServerSignature to 'Prod' in your Apache configuration file.\nOnce you have done this, you can access your virtual host and see that the version information is no longer displayed."
    "Congratulations! You have completed all challenges.\nNow, it's time to harden your Apache configuration.\nYou need to set up a custom 404 error page and disable directory listing.\nYou can do this by creating a custom 404.html file in /var/www/html/errors/ and configuring your virtual host to use it.\nOnce you have done this, you can access your virtual host and see the custom 404 error page.\nYou also need to disable version information in the Apache configuration.\nYou can do this by setting ServerTokens and ServerSignature to 'Prod' in your Apache configuration file.\nOnce you have done this, you can access your virtual host and see that the version information is no longer displayed."
    
)

check_flag() {
    local challenge_num=$1
    local flag=$2

    if [[ -z "$challenge_num" || -z "$flag" ]]; then
        echo "Usage: $0 [challenge_num] [flag] - check the flag"
        return 1
    fi

    if [[ ! "$challenge_num" =~ ^[0-9]+$ ]] || (( challenge_num < 0 || challenge_num >= ${#FLAGS[@]} )); then
        echo "Invalid challenge number. Please provide a valid number."
        return 1
    fi

    local expected_flag=${FLAGS[$challenge_num]}
    local provided_flag=$(echo -n "$flag" | sha256sum | cut -d' ' -f1)

    if [ "$provided_flag" = "$expected_flag" ]; then
        echo "Correct flag for challenge $challenge_num!"
        if [[ $challenge_num -lt $((${#FLAGS[@]} - 1)) ]]; then
            echo -e "${NEXT_LEVEL_CLUE[$challenge_num]}"
        else
            echo "Congratulations! You have completed all challenges."
        fi
        echo "$challenge_num FLAG: $flag" >> ~/.completed_challenge
    else
        echo "Incorrect flag for challenge $challenge_num. Try again!"
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
    echo "Progress: $completed/${#FLAGS[@]} challenges completed."
}

check_hardening() {
    local errors=0
    # Check for custom 404 error page
    CUSTOM_404=$(curl -s http://localhost/errors/404.html | grep -q "Custom 404 - Page Not Found")
    if [ $? -eq 0 ]; then
        echo "Custom 404 error page is set up correctly."
    else
        echo "Custom 404 error page is not set up. Please review your default error page configuration."
        ((errors++))
    fi
    

    # Check for directory listing disabled
    curl -H "Host: challenge6.local" -s http://localhost/ | grep -q "Index of /"
    if [ $? -ne 0 ]; then
        echo "Directory listing is disabled."
    else
        echo "Directory listing is enabled. Please disable it by setting 'Options -Indexes' in your Apache configuration. For challenge6.local, you can do this by editing /etc/apache2/sites-available/challenge6.conf and adding 'Options -Indexes' in the <Directory> section."
        ((errors++))
    fi

    # Check for ServerTokens and ServerSignature set to 'Prod'
    HIDE_INFO=$(curl -LIs http://challenge5.local | awk '/Server/ {print $2}' | tr -d '\r')
    if [ "$HIDE_INFO" = "Apache" ]; then
        echo "Well Done! This configuration avoid leaking information."
    else
        echo "ServerTokens and/or ServerSignature are not set correctly. Make your server more secure"
        ((errors++))
    fi

    if [ $errors -eq 0 ]; then
        echo "Hardening challenge completed successfully!"
        echo "Here's your flag: CTF{HARDENING_COMPLETE}"
    else
        echo "$errors errors found. Please fix them to complete the hardening challenge."
    fi
}
case "$1" in
    "progress")
        show_progress
        ;;
    [0-9])
        check_flag $1 "$2"
        ;;
    hardening)
        echo -e "Last challenge is the hardening challenge.\nYou need to harden the Apache configuration by setting up a custom 404 error page and disabling directory listing.\nYou can do this by creating a custom 404.html file in /var/www/html/errors/ and configuring your virtual host to use it.\nOnce you have done this, you can access your virtual host and see the custom 404 error page."
        echo -e "You also need to disable version information in the Apache configuration.\nYou can do this by setting ServerTokens and ServerSignature to 'Prod' in your Apache configuration file.\nOnce you have done this, you can access your virtual host and see that the version information is no longer displayed."
        echo -e "You can also disable directory listing by setting Options -Indexes in your Apache configuration file.\nOnce you have done this, you can access your virtual host and see that directory listing is disabled."
        echo -e "Let me check your config and give you the last flag"
        check_hardening
        ;;
    *)
        echo "Usage: $0 [challenge_num] [flag] - check the flag"
        echo "Usage: $0 progress - Show the current progress"
        echo "Usage: $0 hardening - Show hardening challenge instructions" 
        ;;
esac