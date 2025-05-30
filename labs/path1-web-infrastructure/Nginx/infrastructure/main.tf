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

module "nginx_ctf_lxc" {
  source = "../../../../modules/lxc"

  proxmox_node_name    = var.proxmox_node_name
  proxmox_datastore_id = var.proxmox_datastore_id_volume
  description          = "LXC container for Nginx CTF"
  lxc_hostname         = "nginx-ctf"
  lxc_ipv4_address     = var.lxc_ipv4_address
  lxc_ipv4_gateway     = var.lxc_ipv4_gateway
  ssh_public_keys      = var.ssh_public_keys
}

resource "null_resource" "nginx_ctf_setup" {
  depends_on = [module.nginx_ctf_lxc]

  connection {
    type        = "ssh"
    host        = module.nginx_ctf_lxc.lxc_ipv4_address
    private_key = file(var.ssh_private_key_path)
    user        = "root"
  }

  provisioner "local-exec" {
    command = "ssh-keygen -R ${module.nginx_ctf_lxc.lxc_ipv4_address} || true"
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
    destination = "/etc/nginx/sites-available/"
  }

  provisioner "file" {
    source      = "./setup/verify.sh"
    destination = "/usr/bin/verify"
  }

  provisioner "remote-exec" {
    script = "./setup/finalizer.sh"
  }
}
