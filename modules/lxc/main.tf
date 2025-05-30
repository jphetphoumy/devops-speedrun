terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.78.0"
    }
  }
}

resource "proxmox_virtual_environment_container" "apache_ctf" {
  description = var.description

  node_name = var.proxmox_node_name

  initialization {
    hostname = var.lxc_hostname

    ip_config {
      ipv4 {
        address = var.lxc_ipv4_address
        gateway      = var.lxc_ipv4_gateway
      }
    }

    user_account {
      keys = var.ssh_public_keys
      password = random_password.debian_container_password.result
    }
  }

  network_interface {
    name = "veth0"
  }

  disk {
    datastore_id = var.proxmox_datastore_id
    size         = 5
  }

  operating_system {
    template_file_id = "local:vztmpl/debian-12.tar.zst"
    # Or you can use a volume ID, as obtained from a "pvesm list <storage>"
    # template_file_id = "local:vztmpl/jammy-server-cloudimg-amd64.tar.gz"
    type = "debian"
  }

  features {
    nesting = true
  }

  startup {
    order      = "3"
    up_delay   = "60"
    down_delay = "60"
  }
}

resource "random_password" "debian_container_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

output "debian_container_password" {
  value     = random_password.debian_container_password.result
  sensitive = true
}

output "lxc_ipv4_address" {
  value = trim(proxmox_virtual_environment_container.apache_ctf.initialization[0].ip_config[0].ipv4[0].address, "/24")
}