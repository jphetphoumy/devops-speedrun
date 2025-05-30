# DevOps Speedrun Lab Generation Prompt

Use this prompt template to generate new labs for various tech stacks in the DevOps Speedrun project.

## Tech Stack Lab Request Template

```
Create a comprehensive lab for [TECHNOLOGY_NAME] following the DevOps Speedrun format. The lab should:

1. Follow the CTF-style challenge structure with progressive difficulty
2. Include 6-7 challenges focused on core concepts and practical skills
3. Provide infrastructure as code (Terraform) for deployment
4. Include all setup scripts and verification mechanisms
5. Follow the established project structure

Tech stack details:
- Name: [Full name of technology]
- Version: [Specific version to use]
- Key concepts to cover: [List 5-7 fundamental concepts]
- Prerequisites: [Any prior knowledge or skills needed]

Output should include:
1. Complete README.md with learning objectives and challenge details
2. Terraform configuration for infrastructure deployment
3. Setup scripts for environment configuration
4. Challenge verification script with flags
5. Any additional configuration files needed for the challenges
```

## Example: Generating a Lab for PostgreSQL

```
Create a comprehensive lab for PostgreSQL following the DevOps Speedrun format. The lab should:

1. Follow the CTF-style challenge structure with progressive difficulty
2. Include 6-7 challenges focused on core concepts and practical skills
3. Provide infrastructure as code (Terraform) for deployment
4. Include all setup scripts and verification mechanisms
5. Follow the established project structure

Tech stack details:
- Name: PostgreSQL Database Server
- Version: 15.x
- Key concepts to cover:
  - Database creation and user management
  - Authentication methods
  - Database schema design
  - Performance tuning and query optimization
  - Backup and recovery procedures
  - Replication setup
  - Security hardening
- Prerequisites: Basic SQL knowledge, Linux command line experience

Output should include:
1. Complete README.md with learning objectives and challenge details
2. Terraform configuration for infrastructure deployment
3. Setup scripts for environment configuration
4. Challenge verification script with flags
5. Any additional configuration files needed for the challenges
```

## Project Structure Guidelines

Each lab should follow this directory structure:

```
labs/
  path[x]-[category]/
    [Technology]/
      README.md           # Lab documentation and challenges
      infrastructure/
        main.tf           # Terraform configuration
        variables.tf      # Terraform variables ( mirror existing file labs, take apache as an example)
        tofu.auto.tfvars.example # Terraform example ( mirror  existing file labs, take apache as an example)
        setup/
          ctf_setup.sh    # Initial environment setup
          finalizer.sh    # Final setup steps
          verify.sh       # Challenge verification script
          [Additional config folders as needed]
          [Technology-specific directories]
```

## Lab Content Guidelines

### README.md Structure
- Overview of the technology
- Learning objectives
- Lab environment description
- Challenge descriptions with hints
- Verification instructions
- Additional resources

### Challenges Design
- Start with basic concepts and increase complexity
- Each challenge should build on skills from previous ones
- Provide clear hints without giving away solutions
- Focus on real-world scenarios and practical applications
- Include both configuration and troubleshooting challenges

### Verification System
- Use hashed flags for challenge verification
- Include helpful clues for the next challenge
- Track completed challenges
- Provide feedback on incorrect solutions

### Infrastructure Requirements
- Use consistent Terraform modules
- Support for different environments
- Proper resource naming and tagging
- Security considerations for lab environment

## Terraform Configuration Example

Below is an example of the `main.tf` file for the Apache lab:

```terraform
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.78.0"
    }
  }
}

provider "proxmox" {
  endpoint = "https://${var.proxmox_ve_endpoint}:8006/api2/json"

  username = "root@pam"
  password = var.proxmox_ve_password

  # because self-signed TLS certificate is in use
  insecure = true

  ssh {
    agent = true
  }
}

module "apache_ctf_lxc" {
  source = "../../../../modules/lxc"

  proxmox_node_name    = var.proxmox_node_name
  proxmox_datastore_id = var.proxmox_datastore_id_volume
  description          = "LXC container for Apache CTF"
  lxc_hostname         = "apache-ctf"
  lxc_ipv4_address     = var.lxc_ipv4_address
  lxc_ipv4_gateway     = var.lxc_ipv4_gateway
  ssh_public_keys      = var.ssh_public_keys
}

resource "null_resource" "apache_ctf_setup" {
  depends_on = [module.apache_ctf_lxc]

  connection {
    type        = "ssh"
    host        = module.apache_ctf_lxc.lxc_ipv4_address
    private_key = file(var.ssh_private_key_path)
    user        = "root"
  }

  provisioner "local-exec" {
    command = "ssh-keygen -R ${module.apache_ctf_lxc.lxc_ipv4_address} || true"
  }

  provisioner "remote-exec" {
    script = "./setup/ctf_setup.sh"
  }

  provisioner "file" {
    source      = "./setup/www"
    destination = "/var"
  }

  provisioner "file" {
    source      = "./setup/sites-available/"
    destination = "/etc/apache2/sites-available/"
  }

  provisioner "file" {
    source      = "./setup/verify.sh"
    destination = "/usr/bin/verify"
  }

  provisioner "remote-exec" {
    script = "./setup/finalizer.sh"
  }
}
```

## What to Change When Creating a New Lab Challenge

When creating a new lab for a different technology stack, you need to make the following modifications:

### 1. Terraform Configuration (`main.tf`) Changes:

- **Module Name**: Replace `module "apache_ctf_lxc"` with `module "[technology]_ctf_lxc"`
- **Description**: Update `"LXC container for Apache CTF"` to `"LXC container for [Technology] CTF"`
- **Hostname**: Change `lxc_hostname = "apache-ctf"` to `lxc_hostname = "[technology]-ctf"`
- **Resource Name**: Update `resource "null_resource" "apache_ctf_setup"` to `resource "null_resource" "[technology]_ctf_setup"`
- **File Provisioners**: Adjust the source and destination paths for file provisioners to match the new technology's configuration files:
  ```terraform
  provisioner "file" {
    source      = "./setup/[technology-specific-folder]"
    destination = "/appropriate/destination/path"
  }
  ```
- **Script Paths**: Ensure all script paths point to your new technology's setup scripts

You can add more VM using the same module. Use for loop or duplicate module block for each additional VM.
### 2. Setup Scripts Changes:

- **ctf_setup.sh**: 
  - Update package installation to include technology-specific packages
  - Modify initial configuration settings
  - Update MOTD with the new technology name and challenge descriptions

- **finalizer.sh**:
  - Adjust file permissions for technology-specific configuration files
  - Update any service restarts or reloads
  - Implement technology-specific finalization steps

- **verify.sh**:
  - Create new hashed flags for each challenge
  - Implement verification logic specific to the technology stack
  - Update clues for the next challenge based on your lab's progression

### 3. Challenge Content:

- Create technology-specific configuration files in the appropriate setup subdirectories
- Prepare sample files, data, or configurations needed for each challenge
- Design challenges that progressively build upon core concepts

### 4. README.md:

- Update all technology references
- Modify challenge descriptions to match your new technology stack
- Adjust learning objectives to highlight key skills for the technology
- Update any technology-specific commands or procedures
- Revise resources section with relevant documentation links

Remember that each lab should be self-contained and provide a complete learning path for the specific technology, while maintaining consistency with the overall project structure and verification system.