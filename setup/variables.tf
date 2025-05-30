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