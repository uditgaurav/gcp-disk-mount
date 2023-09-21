#!/bin/bash

echo "Debug: VM_USER=$VM_USER, INSTANCE_NAME=$INSTANCE_NAME, ZONE=$ZONE, DEVICE_NAME=$DEVICE_NAME, MOUNT_POINT=$MOUNT_POINT, UUID=${1}"

# Create service account JSON file from existing secrets
cat <<EOF > /tmp/service-account.json
{
  "type": "$(cat /etc/cloud-secret/type)",
  "project_id": "$(cat /etc/cloud-secret/project_id)",
  "private_key_id": "$(cat /etc/cloud-secret/private_key_id)",
  "private_key": "$(cat /etc/cloud-secret/private_key)",
  "client_email": "$(cat /etc/cloud-secret/client_email)",
  "client_id": "$(cat /etc/cloud-secret/client_id)",
  "auth_uri": "$(cat /etc/cloud-secret/auth_uri)",
  "token_uri": "$(cat /etc/cloud-secret/token_uri)",
  "auth_provider_x509_cert_url": "$(cat /etc/cloud-secret/auth_provider_x509_cert_url)",
  "client_x509_cert_url": "$(cat /etc/cloud-secret/client_x509_cert_url)"
}
EOF

# Generate SSH keys if not present
if [ ! -f "$HOME/.ssh/google_compute_engine" ]; then
    ssh-keygen -t rsa -f $HOME/.ssh/google_compute_engine -N ""
fi

export CLOUDSDK_CORE_PROJECT=$(cat /etc/cloud-secret/project_id)

# Activate Google Cloud service account
gcloud auth activate-service-account --key-file=/tmp/service-account.json

# Copy the script to the VM
gcloud compute scp ./usr/local/bin/auto_mount.sh $VM_USER@$INSTANCE_NAME:~/ --zone=$ZONE

# SSH into the VM, make the script executable, and run it with UUID as the first argument
gcloud compute ssh $VM_USER@$INSTANCE_NAME --zone=$ZONE --command="chmod +x ~/auto_mount.sh && sudo bash ~/auto_mount.sh '$UUID' '$DEVICE_NAME' '$MOUNT_POINT'"
