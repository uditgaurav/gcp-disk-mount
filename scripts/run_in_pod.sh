#!/bin/bash

cat <<EOF > /tmp/service-account.json
{
  "type": "$(cat /etc/secret-volume/type)",
  "project_id": "$(cat /etc/secret-volume/project_id)",
  "private_key_id": "$(cat /etc/secret-volume/private_key_id)",
  "private_key": "$(cat /etc/secret-volume/private_key)",
  "client_email": "$(cat /etc/secret-volume/client_email)",
  "client_id": "$(cat /etc/secret-volume/client_id)",
  "auth_uri": "$(cat /etc/secret-volume/auth_uri)",
  "token_uri": "$(cat /etc/secret-volume/token_uri)",
  "auth_provider_x509_cert_url": "$(cat /etc/secret-volume/auth_provider_x509_cert_url)",
  "client_x509_cert_url": "$(cat /etc/secret-volume/client_x509_cert_url)"
}
EOF

gcloud auth activate-service-account --key-file=/tmp/service-account.json
gcloud compute ssh $VM_USER@$INSTANCE_NAME --zone=$ZONE --command="bash <(curl -s https://raw.githubusercontent.com/uditgaurav/gcp-disk-mount/master/scripts/auto_mount.sh) $DISK_ID $MOUNT_POINT"
