## Mount Path Setup

| Environment Variable | Description                                                   | Example Value        |
|----------------------|---------------------------------------------------------------|----------------------|
| `VM_USER`            | Username for the VM you are connecting to.                    | `username`           |
| `INSTANCE_NAME`      | Name of the Google Compute Engine instance.                   | `my-instance`        |
| `ZONE`               | The zone where your Google Compute Engine instance is located.| `us-central1-a`      |
| `DEVICE_NAME`            | Identifier for the disk to be mounted.                        | `persistent-disk-1`  |
| `MOUNT_POINT`        | Directory where the disk will be mounted.                     | `/home/user/mount_point` |

## Sample Pod

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
        - name: DEVICE_NAME
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

## Sample Probe

Here is a sample probe reference to mount the disk path.

```yaml
probe:
    - name: disk-mount
    type: cmdProbe
    mode: EOT
    runProperties:
        probeTimeout: 60s
        retry: 0
        interval: 1s
        stopOnFailure: true
    cmdProbe/inputs:
        command: ./usr/local/bin/run_in_pod.sh
        source:
        image: docker.io/chaosnative/gcp:0.1.0
        inheritInputs: false
        env:
          - name: VM_USER
            value: uditgaurav
          - name: INSTANCE_NAME
            value: gke-cluster-1-default-pool-c742a4dd-3mnf
          - name: ZONE
            value: us-central1-c
          - name: DEVICE_NAME
            value: persistent-disk-1
          - name: MOUNT_POINT
            value: /home/uditgaurav/mydisk
        secrets:
            - name: cloud-secret
            mountPath: /etc/
        comparator:
        type: string
        criteria: contains
        value: Disk mounted successfully
```
