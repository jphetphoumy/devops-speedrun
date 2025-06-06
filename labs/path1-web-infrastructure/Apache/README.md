# Apache Web Server Fundamentals Lab

## 🎯 Overview

This lab introduces you to Apache, one of the most widely used web servers in the world. Through a series of CTF-style challenges, you'll learn how Apache works, how to configure it properly, and gain practical skills that are essential for any DevOps engineer or system administrator.

## 🛠️ What You'll Learn

- Apache configuration structure and syntax
- Virtual hosting with Apache
- Security best practices
- URL rewriting and redirects

## 💻 Lab Environment

This lab deploys a Debian-based LXC container with Apache installed but intentionally misconfigured. As a student, you'll have:

- Access to modify Apache configuration files
- Permission to restart/reload the Apache service
- Limited file system access (simulating real-world permission restrictions)
- Access to a verification script to check your progress

## 🚀 Running the Lab

To set up and run the lab, follow these steps:

1. **Prepare the Variables**:
   - Navigate to the `infrastructure` directory.
   - Copy the example `tfvars` file:
     ```bash
     cp tofu.auto.tfvars.example tofu.auto.tfvars
     ```
   - Edit the `tofu.auto.tfvars` file to fill in the required variables.

2. **Initialize Terraform**:
   - Run the following command to initialize the Terraform environment:
     ```bash
     tofu init
     ```

3. **Plan and Apply**:
   - Generate an execution plan:
     ```bash
     tofu plan
     ```
   - Apply the changes to set up the lab:
     ```bash
     tofu apply
     ```

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

### Challenge 4: Basic Authentication

**Scenario**: Configure basic authentication for the challenge4 virtual host to access a protected page.

**Hint**: You'll need to set up a user named 'admin' with the password 'SuperPassword' and configure the appropriate authentication directives in the virtual host.

**Skills Tested**: Implementing HTTP Basic Authentication in Apache, managing credentials securely.

### Challenge 5: URL Rewriting

**Scenario**: Implement a URL rewrite rule that redirects requests from `/getflag` to the appropriate PHP file.

**Hint**: You'll need to enable the rewrite module and add appropriate rewrite rules to the virtual host configuration. Focus on configuring rewrites at the virtual host level rather than using .htaccess.

**Skills Tested**: Configuring mod_rewrite, understanding regular expressions in Apache's rewrite rules.

### Challenge 6: Server Hardening

**Scenario**: Improve the security configuration of the web server by implementing proper error pages and disabling information leakage.

**Hint**: Configure a custom 404 error page from `/var/www/errors/404.html` and prevent Apache from revealing server information in headers and error pages.

**Skills Tested**: Security hardening best practices, error handling configuration, and server information protection.

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
