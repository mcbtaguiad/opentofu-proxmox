# ============================================================================ #
# Author: Mark Taguiad <marktaguiad@tagsdev.xyz>
# ============================================================================ #

#!/bin/bash
wget https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-cloudimg.qcow2
# virt-customize -a Arch-Linux-x86_64-cloudimg.qcow2 --install qemu-guest-agent
qm create 1001 --name "arch-cloudinit-template" --memory 2048 --cores 2 --net0 virtio,bridge=vmbr0
qm importdisk 1001 Arch-Linux-x86_64-cloudimg.qcow2 tags-nvme-thin-pool1
qm set 1001 --scsihw virtio-scsi-pci --scsi0 tags-nvme-thin-pool1:vm-1001-disk-0
qm set 1001 --boot c --bootdisk scsi0
qm set 1001 --ide1 tags-nvme-thin-pool1:cloudinit
qm set 1001 --serial0 socket --vga serial0
qm set 1001 --agent enabled=1
qm template 1001