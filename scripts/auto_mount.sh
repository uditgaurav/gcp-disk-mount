#!/bin/bash

# Function to find the device path based on disk ID
find_device_path() {
  local disk_id=$1
  for dev in /dev/disk/by-id/*; do
    if [[ $dev == *"$disk_id"* ]]; then
      echo $(readlink -f $dev)
      return 0
    fi
  done
  return 1
}

# Check for arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <disk_id> <mount_point>"
  exit 1
fi

# Define variables
DISK_ID="$1"
MOUNT_POINT="$2"
DISK=$(find_device_path $DISK_ID)

# Check if the disk exists
if [ -z "$DISK" ]; then
  echo "Error: Disk with ID $DISK_ID does not exist."
  exit 1
fi

# Check if the mount point exists
if [ ! -d $MOUNT_POINT ]; then
  echo "Creating mount point $MOUNT_POINT..."
  mkdir -p $MOUNT_POINT
fi

# Check if the disk is already mounted to the given path
if mountpoint -q $MOUNT_POINT; then
  echo "Disk is already mounted to $MOUNT_POINT."
  exit 0
fi

# Mount the disk
echo "Mounting $DISK to $MOUNT_POINT..."
sudo mount -o discard,defaults $DISK $MOUNT_POINT

# Automatically add entry to /etc/fstab for mounting at boot
UUID=$(sudo blkid -s UUID -o value $DISK)
echo "Automatically adding UUID=$UUID $MOUNT_POINT ext4 discard,defaults,nofail 0 0 to /etc/fstab..."
echo "UUID=$UUID $MOUNT_POINT ext4 discard,defaults,nofail 0 0" | sudo tee -a /etc/fstab

echo "Disk mounted successfully."
