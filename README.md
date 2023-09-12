# Steps: Setting Up SSH Keys for Password-less Login

- **Generate SSH Keys:** If you haven't already, generate an SSH key pair on your local machine.

```bash
ssh-keygen -t rsa -b 4096
```

This will create a new SSH key, using the provided email as a label. When you run the command, it will ask where to save the key. By default, it saves the key to `~/.ssh/id_rsa`.

- **Copy Public Key to VM:** Copy the public key (`~/.ssh/id_rsa.pub`) to your VM. You can use `ssh-copy-id` for this.

```bash
ssh-copy-id username@vm_ip_address
```

Replace username with your VM `username` and `vm_ip_address` with your VM's IP address.

- **Create Kubernetes Secret:** Create a Kubernetes secret from your SSH private key.

```bash
kubectl create secret generic ssh-key-secret --from-file=ssh-privatekey=/path/to/your/ssh/private/key
```

Replace `/path/to/your/ssh/private/key` with the path to your SSH private key, usually `~/.ssh/id_rsa`.

- **Mount Secret in Pod:** You'll need to mount this secret in your Kubernetes pod so that it can use the SSH key for authentication. This is usually done in the pod's YAML configuration under `spec.volumes` and `spec.containers.volumeMounts`.

```yaml
volumeMounts:
- name: ssh-key
  mountPath: /root/.ssh
```

## Pod to mount the path

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: gcp-disk-mount-pod
  labels:
    purpose: demonstrate-gcp-disk-mount
spec:
  containers:
  - name: gcp-disk-mount-container
    image: uditgaurav/gcp:0.1.0
    imagePullPolicy: Always
    command: ["/bin/sh", "-c"]
    args: ["/usr/local/bin/run_in_pod.sh"]
    env:
      - name: VM_USER
        value: "your_vm_user"
      - name: VM_IP
        value: "your_vm_ip"
      - name: VM_PASS
        value: "your_vm_pass"
      - name: DISK_ID
        value: "your_disk_id"
      - name: MOUNT_POINT
        value: "your_mount_point"

```
