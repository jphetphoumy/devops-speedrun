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

variable "description" {
  description = "Description for the LXC container"
  type        = string
  default     = "LXC container for Apache CTF"
}

variable "lxc_hostname" {
  description = "Hostname for the LXC container"
  type        = string
  default     = "apache-ctf"
}

variable "lxc_ipv4_address" {
  description = "IPv4 address for the LXC container"
  type        = string
  default     = "192.168.1.100"
}

variable "lxc_ipv4_gateway" {
  description = "IPv4 gateway for the LXC container"
  type        = string
  default     = "192.168.1.1"
}

variable "ssh_public_keys" {
  description = "SSH public key to be added to the LXC container for secure access"
  type        = list(string)
  default     = []
}