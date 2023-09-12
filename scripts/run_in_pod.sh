#!/bin/bash

# Variables
VM_USER="$4"  # Replace with the username for the VM
VM_IP="$3"  # Replace with the IP address of the VM
DISK_ID="$1"
MOUNT_POINT="$2"

# SSH into the VM and run the script
ssh -o StrictHostKeyChecking=no $VM_USER@$VM_IP << EOF
  # Download the script
  curl -O https://raw.githubusercontent.com/uditgaurav/gcp-disk-mount/master/scripts/auto_mount.sh
  
  # Make the script executable
  chmod +x auto_mount.sh
  
  # Run the script
  bash auto_mount.sh $DISK_ID $MOUNT_POINT
EOF
