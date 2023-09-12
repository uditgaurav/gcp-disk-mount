#!/bin/bash

# Variables from Environment
VM_USER="${VM_USER}"          
VM_IP="${VM_IP}"               
VM_PASS="${VM_PASS}"        
DISK_ID="${DISK_ID}"   
MOUNT_POINT="${MOUNT_POINT}" 

# SSH into the VM and run the script
sshpass -p $VM_PASS ssh -t -o StrictHostKeyChecking=no $VM_USER@$VM_IP << EOF
  # Download the script
  sudo curl -O https://raw.githubusercontent.com/uditgaurav/gcp-disk-mount/master/scripts/auto_mount.sh
  
  # Make the script executable
  sudo chmod +x auto_mount.sh
  
  # Run the script
  sudo bash auto_mount.sh $DISK_ID $MOUNT_POINT
EOF
