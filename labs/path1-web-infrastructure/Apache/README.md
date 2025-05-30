# Apache Web Server Fundamentals Lab

## 🎯 Overview

This lab introduces you to Apache, one of the most widely used web servers in the world. Through a series of CTF-style challenges, you'll learn how Apache works, how to configure it properly, and gain practical skills that are essential for any DevOps engineer or system administrator.

## 🛠️ What You'll Learn

- Apache configuration structure and syntax
- Virtual hosting with Apache
- Multi-Processing Modules (MPMs)
- Security best practices
- URL rewriting and redirects
- Performance tuning and optimization
- Logging and monitoring

## 💻 Lab Environment

This lab deploys an Ubuntu-based LXC container with Apache installed but intentionally misconfigured. As a student, you'll have:

- Access to modify Apache configuration files
- Permission to restart/reload the Apache service
- Limited file system access (simulating real-world permission restrictions)
- Access to a verification script to check your progress

## 🚩 Challenge Format

This lab is structured as a series of CTF-style challenges. For each challenge you complete, you'll discover a flag in the format `CTF{FLAG_TEXT}`. These flags serve as checkpoints to validate your understanding and progress.

**Important**: The flags are only accessible when you've correctly configured Apache. You cannot access them by reading files directly due to permission restrictions.

## 🎮 Challenges

### Challenge 0: Understanding how to use the verify script
**Scenario**: Before diving into the challenges, familiarize yourself with the verification script that checks your Apache configuration.

Follow the steps written in the motd and submit your first flag by running the script:

```bash
verify 0 CTF{FLAG}
```

### Challenge 1: Access the web server

**Scenario**: The web server is running, but you need to access it to see the default page.

**Hint**: Use `curl` or a web browser to access the server's IP address.

**Skills Tested**: Basic web server access and HTTP methods.

### Challenge 2: Hidden Virtual Hosts
**Scenario**: The server has been configured with a virtual host. Your task is to discover and access the virtual hosts.

**Hint**: Look at existing configuration files to discover hidden hostnames. You'll need to use `curl` with the appropriate headers or configure your `/etc/hosts` file.

**Skills Tested**: Understanding virtual host configurations and how hostname-based routing works.

### Challenge 3: Create a Virtual Host

**Scenario**: You need to create a new virtual host that serves the challenge3 content to read your next flag. the path to the content is `/var/www/challenge3`.

**Hint**: Ensure the virtual host is properly configured with the correct document root and permissions.

**Skills Tested**: Creating and configuring virtual hosts in Apache, understanding document roots.

## ✅ Verification

Run the verification script to check your progress:

```bash
verify.sh <challenge_number> <flag>
```

The script will test your Apache configuration and report which challenges you've completed successfully.

## 📚 Resources

- Apache documentation is available at `/usr/share/doc/apache2/README.Debian.gz`
- Configuration files are located in `/etc/apache2/`
- Error logs can be found at `/var/log/apache2/error.log`
- Access logs can be found at `/var/log/apache2/access.log`

## 🏁 Completion Criteria

To complete this lab, you need to:

1. Successfully configure all virtual hosts
2. Fix all configuration issues
3. Implement all security requirements
4. Optimize for performance
5. Find all the CTF flags

Good luck, and happy hunting!

---

*"The best way to learn Apache is by configuring Apache."*
