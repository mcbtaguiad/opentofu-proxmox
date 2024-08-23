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
        secret_suffix    = "github-actions"
        load_config_file = true
        namespace = var.k8s_namespace_state
        config_path = var.k8s_config_path
    }
}

resource "proxmox_vm_qemu" "tags-p51" {
    count = 1
    name = "github-actions-vm-${count.index + 1}" 
    desc = "github-actions"
    tags = "gitops"
    target_node = var.proxmox_host
    vmid = "20${count.index + 1}"

    clone = var.template_name

    cores   = 1
    sockets = 1
    memory  = 1028
    agent = 1
    
    bios = "seabios"
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"

    sshkeys = <<EOF
    ${var.ssh_key}
    EOF

    os_type   = "cloud-init"
    cloudinit_cdrom_storage = "tags-nvme-thin-pool1"
    ipconfig0 = "ip=192.168.254.6${count.index + 1}/24,gw=192.168.254.254"


    disks {
        scsi {
            scsi0 {
                disk {
                    backup = false
                    size       = 32
                    storage    = "tags-nvme-thin-pool1"
                    emulatessd = false
                }
            }
        }
    }

    network {
        model = "virtio"
        bridge = "vmbr0"
        firewall = true
        link_down = false
    }
}