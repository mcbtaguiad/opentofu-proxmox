# ============================================================================ #
# Author: Mark Taguiad <marktaguiad@tagsdev.xyz>
# ============================================================================ #

terraform {
    required_providers {
        proxmox = {
            source  = "telmate/proxmox"
            version = "3.0.1-rc1"
        }
    }
}
# ============================================================================ #
data "terraform_remote_state" "tagsdev-k8s" {
    backend = "kubernetes"
    config = {
        secret_suffix    = "k8s-local"
        load_config_file = true
        namespace = var.k8s_namespace_state
        config_path = var.k8s_config_path
    }
}

# ============================================================================ #
#                                    MASTER                                    #
# ============================================================================ #
resource "proxmox_vm_qemu" "k8s-master-1" {
    count = 1
    name = "k8s-master-${count.index + 1}" 
    desc = "k8s-master-1"
    tags = "k8s"
    target_node = var.proxmox_host
    vmid = "11${count.index + 1}"

    clone = var.template_name

    cores   = 2
    sockets = 1
    memory  = 2048
    agent = 1
    
    bios = "seabios"
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"

    sshkeys = <<EOF
    ${var.ssh_key}
    EOF

    os_type   = "cloud-init"
    cloudinit_cdrom_storage = "tags-nvme-thin-pool1"
    ipconfig0 = "ip=192.168.254.1${count.index + 1}/24,gw=192.168.254.254"


    disks {
        scsi {
            scsi0 {
                disk {
                    backup = false
                    size       = 25
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
# ============================================================================ #
resource "proxmox_vm_qemu" "k8s-master-2" {
    count = 2
    name = "k8s-master-${count.index + 1}" 
    desc = "k8s-master-${count.index + 1}"
    tags = "k8s"
    target_node = var.proxmox_host
    vmid = "11${count.index + 1}"

    clone = var.template_name

    cores   = 2
    sockets = 1
    memory  = 2048
    agent = 1
    
    bios = "seabios"
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"

    sshkeys = <<EOF
    ${var.ssh_key}
    EOF

    os_type   = "cloud-init"
    cloudinit_cdrom_storage = "tags-nvme-thin-pool1"
    ipconfig0 = "ip=192.168.254.1${count.index + 1}/24,gw=192.168.254.254"


    disks {
        scsi {
            scsi0 {
                disk {
                    backup = false
                    size       = 25
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
# ============================================================================ #
resource "proxmox_vm_qemu" "k8s-master-3" {
    count = 3
    name = "k8s-master-${count.index + 1}" 
    desc = "k8s-master-${count.index + 1}"
    tags = "k8s"
    target_node = var.proxmox_host
    vmid = "11${count.index + 1}"

    clone = var.template_name

    cores   = 2
    sockets = 1
    memory  = 2048
    agent = 1
    
    bios = "seabios"
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"

    sshkeys = <<EOF
    ${var.ssh_key}
    EOF

    os_type   = "cloud-init"
    cloudinit_cdrom_storage = "tags-nvme-thin-pool1"
    ipconfig0 = "ip=192.168.254.1${count.index + 1}/24,gw=192.168.254.254"


    disks {
        scsi {
            scsi0 {
                disk {
                    backup = false
                    size       = 25
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

# ============================================================================ #
#                                    WORKER                                    #
# ============================================================================ #
resource "proxmox_vm_qemu" "k8s-worker-1" {
    count = 1
    name = "k8s-worker-${count.index + 1}" 
    desc = "k8s-worker-${count.index + 1}"
    tags = "k8s"
    target_node = var.proxmox_host
    vmid = "12${count.index + 1}"

    clone = var.template_name

    cores   = 2
    sockets = 1
    memory  = 2048
    agent = 1
    
    bios = "seabios"
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"

    sshkeys = <<EOF
    ${var.ssh_key}
    EOF

    os_type   = "cloud-init"
    cloudinit_cdrom_storage = "tags-nvme-thin-pool1"
    ipconfig0 = "ip=192.168.254.2${count.index + 1}/24,gw=192.168.254.254"


    disks {
        scsi {
            scsi0 {
                disk {
                    backup = false
                    size       = 25
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
# ============================================================================ #
resource "proxmox_vm_qemu" "k8s-worker-2" {
    count = 2
    name = "k8s-worker-${count.index + 1}" 
    desc = "k8s-worker-${count.index + 1}"
    tags = "k8s"
    target_node = var.proxmox_host
    vmid = "12${count.index + 1}"

    clone = var.template_name

    cores   = 2
    sockets = 1
    memory  = 4096
    agent = 1
    
    bios = "seabios"
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"

    sshkeys = <<EOF
    ${var.ssh_key}
    EOF

    os_type   = "cloud-init"
    cloudinit_cdrom_storage = "tags-nvme-thin-pool1"
    ipconfig0 = "ip=192.168.254.2${count.index + 1}/24,gw=192.168.254.254"


    disks {
        scsi {
            scsi0 {
                disk {
                    backup = false
                    size       = 25
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
# ============================================================================ #
resource "proxmox_vm_qemu" "k8s-worker-3" {
    count = 3
    name = "k8s-worker-${count.index + 1}" 
    desc = "k8s-worker-${count.index + 1}"
    tags = "k8s"
    target_node = var.proxmox_host
    vmid = "12${count.index + 1}"

    clone = var.template_name

    cores   = 4
    sockets = 1
    memory  = 6144
    agent = 1
    
    bios = "seabios"
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"

    sshkeys = <<EOF
    ${var.ssh_key}
    EOF

    os_type   = "cloud-init"
    cloudinit_cdrom_storage = "tags-nvme-thin-pool1"
    ipconfig0 = "ip=192.168.254.2${count.index + 1}/24,gw=192.168.254.254"


    disks {
        scsi {
            scsi0 {
                disk {
                    backup = false
                    size       = 25
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
# ============================================================================ #
#                                    WORKER                                    #
# ============================================================================ #
resource "proxmox_vm_qemu" "k8s-storage-1" {
    count = 1
    name = "k8s-storage-${count.index + 1}" 
    desc = "k8s-storage-${count.index + 1}"
    tags = "k8s"
    target_node = var.proxmox_host
    vmid = "13${count.index + 1}"

    clone = var.template_name

    cores   = 1
    sockets = 1
    memory  = 2048
    agent = 1
    
    bios = "seabios"
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"

    sshkeys = <<EOF
    ${var.ssh_key}
    EOF

    os_type   = "cloud-init"
    cloudinit_cdrom_storage = "tags-nvme-thin-pool1"
    ipconfig0 = "ip=192.168.254.3${count.index + 1}/24,gw=192.168.254.254"


    disks {
        scsi {
            scsi0 {
                disk {
                    backup = false
                    size       = 25
                    storage    = "tags-nvme-thin-pool1"
                    emulatessd = false
                }
            }
            scsi1 {
                disk {
                    backup = false
                    size       = 200
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
# ============================================================================ #
resource "proxmox_vm_qemu" "k8s-storage-2" {
    count = 2
    name = "k8s-storage-${count.index + 1}" 
    desc = "k8s-storage-${count.index + 1}"
    tags = "k8s"
    target_node = var.proxmox_host
    vmid = "13${count.index + 1}"

    clone = var.template_name

    cores   = 1
    sockets = 1
    memory  = 2048
    agent = 1
    
    bios = "seabios"
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"

    sshkeys = <<EOF
    ${var.ssh_key}
    EOF

    os_type   = "cloud-init"
    cloudinit_cdrom_storage = "tags-nvme-thin-pool1"
    ipconfig0 = "ip=192.168.254.3${count.index + 1}/24,gw=192.168.254.254"


    disks {
        scsi {
            scsi0 {
                disk {
                    backup = false
                    size       = 25
                    storage    = "tags-nvme-thin-pool1"
                    emulatessd = false
                }
            }
            scsi1 {
                disk {
                    backup = false
                    size       = 600
                    storage    = "tags-hdd-pool1"
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