## Mount Path Setup

| Environment Variable | Description                                       | Example Value            |
|----------------------|---------------------------------------------------|--------------------------|
| `VM_USER`            | Username for the VM you are connecting to.        | `username`               |
| `VM_IP`              | IP address of the VM you are connecting to.       | `192.168.1.1`            |
| `VM_PASS`            | Password for the SSH user of the VM.              | `password`               |
| `DISK_ID`            | Identifier for the disk to be mounted.            | `persistent-disk-1`      |
| `MOUNT_POINT`        | Directory where the disk will be mounted.         | `/home/user/mount_point` |

## Create Secret For VM Password

Use the following command to create secret for VM Password.

```bash
kubectl create secret generic vm-pass -n hce  --from-literal=VM_PASS=myvmpassword
```

Note: Here `hce` is the CHAOS_NAMESPACE (where the chaos infra is installed) and `myvmpassword` is a dummy password for your reference. 

## Sample Pod With Password

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
