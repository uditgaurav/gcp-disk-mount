#!/bin/bash

find_device_path_by_uuid() {
  local UUID=$1
  local DEVICE=$(sudo blkid | grep "UUID=\"$UUID\"" | awk -F ':' '{print $1}')
  if [ -z "$DEVICE" ]; then
    echo "Error: Unable to find device with UUID $UUID."
    exit 1
  fi
  echo "$DEVICE"
}

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <uuid> <mount_point> [mount_options]"
  exit 1
fi

UUID="$1"
MOUNT_POINT="$2"
MOUNT_OPTIONS="${3:-$MOUNT_OPTIONS}"

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
    echo "Path $MOUNT_POINT had a stale mount. Unmounted it successfully."
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
if [ -z "$MOUNT_OPTIONS" ]; then
  sudo mount $DISK $MOUNT_POINT
else
  sudo mount -o $MOUNT_OPTIONS $DISK $MOUNT_POINT
fi

if [ $? -ne 0 ]; then
  echo "Error: Unable to mount $DISK to $MOUNT_POINT."
  exit 1
fi

echo "Updating /etc/fstab..."
if [ -z "$MOUNT_OPTIONS" ]; then
    echo "UUID=$UUID $MOUNT_POINT ext4 defaults 0 0" | sudo tee -a /etc/fstab
else
    echo "UUID=$UUID $MOUNT_POINT ext4 $MOUNT_OPTIONS 0 0" | sudo tee -a /etc/fstab
fi

if [ $? -ne 0 ]; then
  echo "Error: Unable to update /etc/fstab."
  exit 1
fi

echo "Disk mounted successfully."
