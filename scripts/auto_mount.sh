#!/bin/bash

find_device_path_by_uuid() {
  local UUID=$1
  local DEVICE=$(sudo blkid | grep "$UUID" | awk -F ':' '{print $1}')
  if [ -z "$DEVICE" ]; then
    echo "Error: Unable to find device with UUID $UUID."
    exit 1
  fi
  echo "$DEVICE"
}

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <uuid> <device_name> <mount_point>"
  exit 1
fi

UUID="$1"
DEVICE_NAME="$2"
MOUNT_POINT="$3"

DISK=$(find_device_path_by_uuid $UUID)

if [ -z "$DISK" ]; then
  echo "Error: Disk with UUID $UUID does not exist."
  exit 1
fi

STALE_MOUNT=$(df -h | grep "$MOUNT_POINT")

if [ ! -z "$STALE_MOUNT" ]; then
  echo "Unmounting stale mount at $MOUNT_POINT..."
  sudo umount $MOUNT_POINT
  if [ $? -ne 0 ]; then
    echo "Error: Unable to unmount stale mount at $MOUNT_POINT."
    exit 1
  else
    echo "Path $MOUNT_POINT was already present. Unmounted it successfully."
    exit 0
  fi
fi

if [ ! -d $MOUNT_POINT ]; then
  echo "Creating mount point $MOUNT_POINT..."
  mkdir -p $MOUNT_POINT
  if [ $? -ne 0 ]; then
    echo "Error: Unable to create mount point at $MOUNT_POINT."
    exit 1
  fi
fi

echo "Mounting $DISK to $MOUNT_POINT..."
sudo mount -o discard,defaults $DISK $MOUNT_POINT 2>&1 | grep -q "already mounted" 
if [ $? -eq 0 ]; then
  echo "Device $DISK is already mounted at $MOUNT_POINT. So Disk mounted successfully."
  exit 0
elif [ $? -ne 0 ]; then
  echo "Error: Unable to mount $DISK to $MOUNT_POINT."
  exit 1
fi

echo "Automatically adding UUID=$UUID $MOUNT_POINT ext4 discard,defaults,nofail 0 0 to /etc/fstab..."
echo "UUID=$UUID $MOUNT_POINT ext4 discard,defaults,nofail 0 0" | sudo tee -a /etc/fstab
if [ $? -ne 0 ]; then
  echo "Error: Unable to update /etc/fstab."
  exit 1
fi

echo "Disk mounted successfully."
