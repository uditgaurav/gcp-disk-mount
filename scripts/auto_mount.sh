#!/bin/bash

find_device_path() {
  local DEVICE_NAME=$1
  for dev in /dev/disk/by-id/*; do
    if [[ $dev == *"$DEVICE_NAME"* ]]; then
      echo $(readlink -f $dev)
      return 0
    fi
  done
  return 1
}

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <device_name> <mount_point>"
  exit 1
fi

DEVICE_NAME="$1"
MOUNT_POINT="$2"
DISK=$(find_device_path $DEVICE_NAME)

if [ -z "$DISK" ]; then
  echo "Error: Disk with ID $DEVICE_NAME does not exist."
  exit 1
fi

if [ ! -d $MOUNT_POINT ]; then
  echo "Creating mount point $MOUNT_POINT..."
  mkdir -p $MOUNT_POINT
fi

if mountpoint -q $MOUNT_POINT; then
  echo "Disk is already mounted to $MOUNT_POINT."
  echo "Disk mounted successfully."
  exit 0
fi

# Mount the disk
echo "Mounting $DISK to $MOUNT_POINT..."
sudo mount -o discard,defaults $DISK $MOUNT_POINT

UUID=$(sudo blkid -s UUID -o value $DISK)
echo "Automatically adding UUID=$UUID $MOUNT_POINT ext4 discard,defaults,nofail 0 0 to /etc/fstab..."
echo "UUID=$UUID $MOUNT_POINT ext4 discard,defaults,nofail 0 0" | sudo tee -a /etc/fstab

echo "Disk mounted successfully."
