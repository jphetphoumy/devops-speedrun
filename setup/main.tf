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

# Download LXC templates for the lab
resource "proxmox_virtual_environment_download_file" "debian_12_lxc_template" {
  content_type       = "vztmpl"
  datastore_id       = var.proxmox_datastore_id
  file_name          = "debian-12.tar.zst"
  node_name          = var.proxmox_node_name
  url                = "http://download.proxmox.com/images/system/debian-12-standard_12.7-1_amd64.tar.zst"
  checksum           = ""
  checksum_algorithm = "sha512"
}
