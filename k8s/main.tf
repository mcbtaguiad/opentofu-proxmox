# ============================================================================ #
# Author: Mark Taguiad <marktaguiad@tagsdev.xyz>
# ============================================================================ #
terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "3.0.2-rc06"
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
    count = 3
    name = "k8s-master-${count.index + 1}" 
    description = "k8s-master-${count.index + 1}" 
    tags = "k8s"
    target_node = var.proxmox_host
    vmid = "11${count.index + 1}"
    vm_state    = "running"
    automatic_reboot = true


    clone = var.template_name

    cores   = 2
    sockets = 1
    memory  = 2560
    agent = 1
    
    bios = "seabios"
    scsihw = "virtio-scsi-pci"
    bootdisk = "scsi0"

    sshkeys = <<EOF
    ${var.ssh_key}
    EOF
    
    
    os_type   = "cloud-init"
    # cloudinit_cdrom_storage = "tags-nvme-thin-pool1"
    ipconfig0 = "ip=192.168.254.1${count.index + 1}/24,gw=192.168.254.254"
    skip_ipv6  = true
    cicustom   = "vendor=local:snippets/qemu-guest-agent.yml" # /var/lib/vz/snippets/qemu-guest-agent.yml
    ciupgrade  = true
    nameserver = "1.1.1.1 8.8.8.8"

    serial {
        id = 0
    }



    disks {
        ide {
            ide1 {
                cloudinit {
                    storage = "pve-thin-pool"
                }
            }
        }
        scsi {
            scsi0 {
                disk {
                    backup = false
                    size       = 25
                    storage    = "pve-thin-pool"
                    emulatessd = false
                }
            }
        }
    }

    network {
        id = 0
        model = "virtio"
        bridge = "vmbr0"
        firewall = true
        link_down = false
    }
}
# ============================================================================ #
#                                    WORKER                                    #
# ============================================================================ #
resource "proxmox_vm_qemu" "k8s-worker" {
    count = 2
    name = "k8s-worker-${count.index + 1}" 
    description = "k8s-worker-${count.index + 1}"
    tags = "k8s"
    target_node = var.proxmox_host
    vmid = "12${count.index + 1}"
    vm_state    = "running"
    automatic_reboot = true


    clone = var.template_name

    cores   = 4
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
    # cloudinit_cdrom_storage = "tags-nvme-thin-pool1"
    ipconfig0 = "ip=192.168.254.2${count.index + 1}/24,gw=192.168.254.254"
    cicustom   = "vendor=local:snippets/qemu-guest-agent.yml" # /var/lib/vz/snippets/qemu-guest-agent.yml
    ciupgrade  = true
    nameserver = "1.1.1.1 8.8.8.8"

    
    serial {
        id = 0
    }


    disks {
        ide {
            ide1 {
                cloudinit {
                    storage = "pve-thin-pool"
                }
            }
        }
        scsi {
            scsi0 {
                disk {
                    backup = false
                    size       = 25
                    storage    = "pve-thin-pool"
                    emulatessd = false
                }
            }
        }
    }

    network {
        id = 0
        model = "virtio"
        bridge = "vmbr0"
        firewall = true
        link_down = false
    }
}
# ============================================================================ #
#                                   STORAGE                                    #
# ============================================================================ #
# resource "proxmox_vm_qemu" "k8s-storage" {
#     count = 1
#     name = "k8s-storage-${count.index + 1}" 
#     description = "k8s-storage-${count.index + 1}"
#     tags = "k8s"
#     target_node = var.proxmox_host
#     vmid = "13${count.index + 1}"

#     clone = var.template_name

#     cores   = 8
#     sockets = 1
#     memory  = 8192
#     agent = 1
    
#     bios = "seabios"
#     scsihw = "virtio-scsi-pci"
#     bootdisk = "scsi0"

#     sshkeys = <<EOF
#     ${var.ssh_key}
#     EOF

#     os_type   = "cloud-init"
#     # cloudinit_cdrom_storage = "tags-nvme-thin-pool1"
#     ipconfig0 = "ip=192.168.254.3${count.index + 1}/24,gw=192.168.254.254"


#     disks {
#         ide {
#             ide1 {
#                 cloudinit {
#                     storage = "tags-nvme-thin-pool1"
#                 }
#             }
#         }
#         scsi {
#             scsi0 {
#                 disk {
#                     backup = false
#                     size       = 25
#                     storage    = "tags-nvme-thin-pool1"
#                     emulatessd = false
#                 }
#             }
#             scsi1 {
#                 disk {
#                     backup = false
#                     size       = 200
#                     storage    = "tags-nvme-thin-pool1"
#                     emulatessd = false
#                 }
#             }
#             scsi2 {
#                 disk {
#                     backup = false
#                     size       = 512
#                     storage    = "tags-hdd-thin-pool1"
#                     emulatessd = false
#                 }
#             }
            
#         }
#     }

#     network {

#         model = "virtio"
#         bridge = "vmbr0"
#         firewall = true
#         link_down = false
#     }
# }