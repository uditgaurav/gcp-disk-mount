## Mount Path Setup

| Environment Variable | Description                                       | Example Value            |
|----------------------|---------------------------------------------------|--------------------------|
| `VM_USER`            | Username for the VM you are connecting to.        | `username`               |
| `DISK_ID`            | Identifier for the disk to be mounted.            | `persistent-disk-1`      |
| `MOUNT_POINT`        | Directory where the disk will be mounted.         | `/home/user/mount_point` |

## Sample Pod With Password

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  namespace: hce
spec:
  containers:
    - name: my-container
      image: uditgaurav/gcp:0.1.0
      imagePullPolicy: Always
      command: ["/bin/sh", "-c"]
      args: ["sleep 10000"]
      env:
        - name: VM_USER
          value: "uditgaurav"
        - name: INSTANCE_NAME
          value: "gke-cluster-1-default-pool-c742a4dd-3mnf"
        - name: ZONE
          value: "us-central1-c"
        - name: DISK_ID
          value: "persistent-disk-1"
        - name: MOUNT_POINT
          value: "/home/uditgaurav/mydisk"
      volumeMounts:
        - name: cloud-secret-volume
          mountPath: /etc/cloud-secret
  volumes:
    - name: cloud-secret-volume
      secret:
        secretName: cloud-secret

```
