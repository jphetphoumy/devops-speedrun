# Nginx Web Server Fundamentals Lab

## 🎯 Overview

This lab introduces you to Nginx, one of the most powerful and versatile web servers in the world. Through a series of CTF-style challenges, you'll learn how Nginx works, how to configure it properly, and gain practical skills that are essential for any DevOps engineer or system administrator.

## 🛠️ What You'll Learn

- Nginx configuration structure and syntax
- Server blocks (virtual hosts) with Nginx
- Worker processes and connections
- Security best practices
- URL rewriting and redirects
- Performance tuning and optimization
- Logging and monitoring

## 💻 Lab Environment

This lab deploys an Ubuntu-based LXC container with Nginx installed but intentionally misconfigured. As a student, you'll have:

- Access to modify Nginx configuration files
- Permission to restart/reload the Nginx service
- Limited file system access (simulating real-world permission restrictions)
- Access to a verification script to check your progress

## 🚩 Challenge Format

This lab is structured as a series of CTF-style challenges. For each challenge you complete, you'll discover a flag in the format `CTF{FLAG_TEXT}`. These flags serve as checkpoints to validate your understanding and progress.

**Important**: The flags are only accessible when you've correctly configured Nginx. You cannot access them by reading files directly due to permission restrictions.

## 🎮 Challenges

### Challenge 0: Understanding how to use the verify script
**Scenario**: Before diving into the challenges, familiarize yourself with the verification script that checks your Nginx configuration.

Follow the steps written in the motd and submit your first flag by running the script:

```bash
verify 0 CTF{FLAG}
```

### Challenge 1: Access the web server

**Scenario**: The web server is running, but you need to access it to see the default page.

**Hint**: Use `curl` or a web browser to access the server's IP address.

**Skills Tested**: Basic web server access and HTTP methods.

### Challenge 2: Hidden Server Blocks
**Scenario**: The server has been configured with server blocks. Your task is to discover and access these hidden server blocks.

**Hint**: Look at existing configuration files to discover hidden hostnames. You'll need to use `curl` with the appropriate headers or configure your `/etc/hosts` file.

**Skills Tested**: Understanding server blocks configurations and how hostname-based routing works.

### Challenge 3: Create a Server Block

**Scenario**: You need to create a new server block that serves the challenge3 content to read your next flag. The path to the content is `/var/www/challenge3`.

**Hint**: Ensure the server block is properly configured with the correct root directive and permissions.

**Skills Tested**: Creating and configuring server blocks in Nginx, understanding root directives.

### Challenge 4: Basic Authentication

**Scenario**: Configure basic authentication for the challenge4 server block to access a protected page.

**Hint**: You'll need to set up a user named 'admin' with the password 'SuperPassword' and configure the appropriate authentication directives in the server block.

**Skills Tested**: Implementing HTTP Basic Authentication in Nginx, managing credentials securely.

### Challenge 5: URL Rewriting

**Scenario**: Implement a URL rewrite rule that redirects requests from `/getflag` to the appropriate PHP file.

**Hint**: You'll need to add appropriate rewrite rules to the server block configuration. Focus on configuring rewrites at the server block level.

**Skills Tested**: Configuring rewrite directives, understanding regular expressions in Nginx's rewrite rules.

### Challenge 6: Server Hardening

**Scenario**: Improve the security configuration of the web server by implementing proper error pages and disabling information leakage.

**Hint**: Configure a custom 404 error page from `/var/www/errors/404.html` and prevent Nginx from revealing server information in headers and error pages.

**Skills Tested**: Security hardening best practices, error handling configuration, and server information protection.

## ✅ Verification

Run the verification script to check your progress:

```bash
verify.sh <challenge_number> <flag>
```

The script will test your Nginx configuration and report which challenges you've completed successfully.

## 📚 Resources

- Nginx documentation is available at `/usr/share/doc/nginx/README.Debian.gz`
- Configuration files are located in `/etc/nginx/`
- Error logs can be found at `/var/log/nginx/error.log`
- Access logs can be found at `/var/log/nginx/access.log`

## 🏁 Completion Criteria

To complete this lab, you need to:

1. Successfully configure all server blocks
2. Fix all configuration issues
3. Implement all security requirements
4. Optimize for performance
5. Find all the CTF flags

Good luck, and happy hunting!

---

*"The best way to learn Nginx is by configuring Nginx."*
