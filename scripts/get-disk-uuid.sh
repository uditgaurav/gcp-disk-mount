#!/bin/bash

if [ -z "$1" ]; then
  echo "Error: No mount path provided."
  exit 1
fi

MOUNT_PATH=$1

if [ ! -d "$MOUNT_PATH" ]; then
  echo "Error: The specified mount path does not exist."
  exit 1
fi

DEVICE_NAME=$(df "$MOUNT_PATH" | awk 'NR==2 {print $1}')

if [ -z "$DEVICE_NAME" ]; then
  echo "Error: Could not find the device mounted at $MOUNT_PATH."
  exit 1
fi

PARENT_DEVICE=$(lsblk -no pkname "$DEVICE_NAME")

if [ -z "$PARENT_DEVICE" ]; then
  PARENT_DEVICE=$(basename "$DEVICE_NAME")
fi

if [ -z "$PARENT_DEVICE" ]; then
  echo "Error: Could not find the parent device for $DEVICE_NAME."
  exit 1
fi

UUID=$(blkid -s UUID -o value "/dev/$PARENT_DEVICE")

if [ -z "$UUID" ]; then
  echo "Error: Could not find the UUID for /dev/$PARENT_DEVICE."
  exit 1
fi

echo "$UUID"
