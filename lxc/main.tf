terraform {
    required_providers {
        proxmox = {
            source  = "telmate/proxmox"
            version = "3.0.1-rc1"
        }
    }
}

data "terraform_remote_state" "tagsdev-k8s" {
    backend = "kubernetes"
    config = {
        secret_suffix    = "lxc-tags-p51"
        load_config_file = true
        namespace = var.k8s_namespace_state
        config_path = var.k8s_config_path
    }
}

resource "proxmox_lxc" "lxc-dns" {
    count = 1
    vmid = "30${count.index}"
    target_node  = "tags-p51"
    hostname     = "lxc-dns"
    console = true
    cpuunits = 256
    swap = 1028
    memory = 512
    arch = "amd64"
    ostemplate   = "local:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst"
    password     = var.lxc_password
    unprivileged = false

    ssh_public_keys = <<-EOT
        ${var.ssh_key}
    EOT

    rootfs {
        storage = "tags-nvme-thin-pool1"
        size    = "16G"
    }

    network {
        name = "eth0"
        bridge = "vmbr0"
        ip = "192.168.254.8${count.index}/24"
        gw = "192.168.254.254"
        firewall = true
    }
}


resource "proxmox_lxc" "lxc-actions" {
    count = 1
    vmid = "31${count.index}"
    target_node  = "tags-p51"
    hostname     = "lxc-actions"
    console = true
    cpuunits = 1028
    swap = 2048
    memory = 1028
    arch = "amd64"
    ostemplate   = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst"
    password     = var.lxc_password
    unprivileged = false

    ssh_public_keys = <<-EOT
        ${var.ssh_key}
    EOT

    rootfs {
        storage = "tags-nvme-thin-pool1"
        size    = "64G"
    }

    network {
        name = "eth0"
        bridge = "vmbr0"
        ip = "192.168.254.8${count.index + 1}/24"
        gw = "192.168.254.254"
        firewall = true
    }
}