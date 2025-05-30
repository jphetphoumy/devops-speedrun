variable "proxmox_ve_endpoint" {
  description = "The endpoint URL of the Proxmox VE API (e.g., https://proxmox.example.com:8006/api2/json)"
  type        = string
}

variable "proxmox_ve_password" {
  description = "Password for the Proxmox VE API user (root@pam)"
  type        = string
  sensitive   = true
}

variable "proxmox_node_name" {
  description = "Name of the Proxmox VE node to deploy resources on"
  type        = string
  default     = "pve"
}

variable "proxmox_datastore_id" {
  description = "ID of the Proxmox datastore to store the LXC templates"
  type        = string
  default     = "local"
}

variable "proxmox_datastore_id_volume" {
  description = "ID of the Proxmox datastore to store the LXC templates"
  type        = string
  default     = "local-lvm"
}

variable "ssh_public_keys" {
  description = "SSH public key to be added to the LXC container for secure access"
  type        = list(string)
  default     = []
}

variable "ssh_private_key_path" {
  description = "Path to the SSH private key for secure access to the LXC container"
  type        = string
  default     = "~/.ssh/id_ed25519"
}

variable "lxc_ipv4_address" {
  description = "IPv4 address for the LXC container"
  type        = string
}

variable "lxc_ipv4_gateway" {
  description = "IPv4 gateway for the LXC container"
  type        = string
  default     = "192.168.1.1"
}