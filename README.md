# DevOps Speedrun: Hands-on Infrastructure Learning Labs

A comprehensive, practical approach to learning DevOps through interactive labs using Proxmox, OpenTofu, Ansible, and more.

## 🚀 Overview

> [!IMPORTANT]  
> This repository contains a series of hands-on CTF-style labs designed to teach DevOps practices using real-world technologies. Each lab provides infrastructure-as-code templates that can be directly deployed to a Proxmox hypervisor, primarily using lightweight LXC containers to minimize resource requirements.

## 🔧 Prerequisites

Before you begin, make sure you have the following installed:

- **OpenTofu** (v1.8.3 or later) - [Installation Guide](https://opentofu.org/docs/intro/install/)
- **Ansible** (v2.14.0 or later) - [Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- **Git** - [Installation Guide](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- **SSH Client** with SSH agent configured
- **Proxmox VE Server/Cluster** (v8.3.5 or later) with API access

## 🚦 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/devops-speedrun.git
cd devops-speedrun
```

### 2. Set Up Lab Environment

First, you need to set up the lab environment by preparing the necessary templates in your Proxmox server:

```bash
# Navigate to the setup directory
cd setup

# Initialize OpenTofu
tofu init

# Create your configuration
cp tofu.tfvars.example tofu.auto.tfvars
```

Edit `tofu.auto.tfvars` with your Proxmox credentials and configuration:

```
proxmox_ve_endpoint = "your-proxmox-server-ip"
proxmox_ve_password = "your-root-password-here"
proxmox_node_name = "pve"  # Change to your node name if different
proxmox_datastore_id = "local"
```

Apply the setup configuration:

```bash
# Preview changes
tofu plan

# Apply changes to download templates and prepare environment
tofu apply
```

This step downloads and prepares all necessary LXC templates and sets up the base environment. You only need to do this once.

### 3. Choose and Start a Lab

Navigate to the lab you want to complete:

```bash
cd labs/path1-web-infrastructure
```

Choose a specific lab (e.g., Apache, Nginx, etc.) and navigate to it:

```bash
cd Apache
```

Read the lab's README.md file for specific instructions and learning objectives:

```bash
cat README.md
```

### 4. Deploy Lab Infrastructure

Each lab has its own infrastructure directory that contains the OpenTofu configuration:

```bash
cd infrastructure
tofu init
tofu apply
```

This will create the lab-specific containers or VMs in your Proxmox environment, preconfigured for the lab's challenges.

### 5. Complete Lab Challenges

Follow the instructions in the lab's README.md to complete the challenges. Each challenge will have you:

1. Configure specific aspects of the technology being taught
2. Find CTF-style flags that validate your understanding
3. Use the verification script to check your progress

```bash
# Example verification command (run inside lab container)
./verify.sh
```

### 6. Clean Up After Completion

When you're finished with a lab, clean up the resources:

```bash
# In the lab's infrastructure directory
tofu destroy
```

## 🏆 Learning Paths

### Path 1: Web Infrastructure Fundamentals
- **Lab 1.1**: Web Server Fundamentals with Apache & Nginx

## 🏁 Advanced Challenges

Completing all paths unlocks advanced CTF-style challenges:

- **Challenge Alpha**: "The Broken Pipeline" - Fix a complex, multi-stage CI/CD pipeline with multiple failure points
- **Challenge Beta**: "Scale Under Fire" - Handle a simulated traffic spike with dynamic scaling
- **Challenge Omega**: "Incident Response" - Detect and mitigate a simulated security breach

## ❓ Troubleshooting

### Common Issues

1. **Connection issues to Proxmox**
   - Verify your Proxmox API endpoint and credentials
   - Check that your Proxmox server has API access enabled
   - Ensure you've set `insecure = true` if using self-signed certificates

2. **Permission errors**
   - Verify that your Proxmox user has sufficient privileges
   - Check that SSH keys are properly configured

3. **Template download fails**
   - Ensure your Proxmox server has internet access
   - Verify storage has sufficient space

## 📜 License

This project is licensed under the MIT License - see the `LICENSE` file for details.

---

*"The best way to learn DevOps is by doing DevOps."*
