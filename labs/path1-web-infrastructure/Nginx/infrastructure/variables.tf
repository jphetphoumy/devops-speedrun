variable "proxmox_ve_endpoint" {
  description = "The endpoint for the Proxmox VE API"
  type        = string
}

variable "proxmox_ve_password" {
  description = "The password for the Proxmox VE API"
  type        = string
  sensitive   = true
}

variable "proxmox_node_name" {
  description = "The name of the Proxmox VE node"
  type        = string
}

variable "proxmox_datastore_id_volume" {
  description = "The ID of the Proxmox VE datastore for volumes"
  type        = string
}

variable "lxc_ipv4_address" {
  description = "The IPv4 address for the LXC container"
  type        = string
}

variable "lxc_ipv4_gateway" {
  description = "The IPv4 gateway for the LXC container"
  type        = string
}

variable "ssh_public_keys" {
  description = "The SSH public keys to add to the LXC container"
  type        = list(string)
}

variable "ssh_private_key_path" {
  description = "The path to the SSH private key to use for provisioning"
  type        = string
}
