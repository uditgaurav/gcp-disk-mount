#!/bin/bash

echo "Debug: VM_USER=$VM_USER, INSTANCE_NAME=$INSTANCE_NAME, ZONE=$ZONE, DEVICE_NAME=$DEVICE_NAME, MOUNT_POINT=$MOUNT_POINT"

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

if [ ! -f "/root/.ssh/google_compute_engine" ]; then
    ssh-keygen -t rsa -f /root/.ssh/google_compute_engine -N ""
fi

gcloud auth activate-service-account --key-file=/tmp/service-account.json
gcloud compute ssh $VM_USER@$INSTANCE_NAME --zone=$ZONE --command="sudo bash <(curl -s https://raw.githubusercontent.com/uditgaurav/gcp-disk-mount/master/scripts/get-disk-uuid.sh) ${1} $DEVICE_NAME $MOUNT_POINT"
