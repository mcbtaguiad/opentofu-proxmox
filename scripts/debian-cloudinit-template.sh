# ============================================================================ #
# Author: Mark Taguiad <marktaguiad@tagsdev.xyz>
# ============================================================================ #

#!/bin/bash

# debian cloud init
wget https://cloud.debian.org/images/cloud/bookworm/20240717-1811/debian-12-generic-amd64-20240717-1811.qcow2
virt-customize -a debian-12-generic-amd64-20240717-1811.qcow2 --install qemu-guest-agent
qm create 1002 --name "debian-20240717-cloudinit-template" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 1002 debian-12-generic-amd64-20240717-1811.qcow2 tags-nvme-thin-pool1
qm set 1002 --scsihw virtio-scsi-pci --scsi0 tags-nvme-thin-pool1:vm-1002-disk-0
qm set 1002 --boot c --bootdisk scsi0
qm set 1002 --ide1 tags-nvme-thin-pool1:cloudinit
qm set 1002 --serial0 socket --vga serial0
qm set 1002 --agent enabled=1
qm template 1002