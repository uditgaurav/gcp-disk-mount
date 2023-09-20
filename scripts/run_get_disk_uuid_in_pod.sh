#!/bin/bash

exec 3>&1 4>&2 > /dev/null 2>&1

echo "Debug: VM_USER=$VM_USER, INSTANCE_NAME=$INSTANCE_NAME, ZONE=$ZONE, MOUNT_POINT=$MOUNT_POINT"

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

if [ ! -f "$HOME/.ssh/google_compute_engine" ]; then
    ssh-keygen -t rsa -f $HOME/.ssh/google_compute_engine -N ""
fi

export CLOUDSDK_CORE_PROJECT=$(cat /etc/cloud-secret/project_id)

gcloud auth activate-service-account --key-file=/tmp/service-account.json
gcloud compute scp ./usr/local/bin/get-disk-uuid.sh $VM_USER@$INSTANCE_NAME:~/ --zone=$ZONE


exec > /dev/fd/3 2>/dev/fd/4

UUID_OUTPUT=$(gcloud compute ssh $VM_USER@$INSTANCE_NAME --zone=$ZONE --command="chmod +x ~/get-disk-uuid.sh && sudo bash ~/get-disk-uuid.sh $MOUNT_POINT")
echo $UUID_OUTPUT | awk '{ print $NF }' 
