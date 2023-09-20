FROM alpine:3.17.4

RUN apk --update add \
        sudo \
        curl \
        tar \
        openssh-client \
        python3 \
        py3-pip \
        && ln -sf python3 /usr/bin/python

# Installing Google Cloud SDK CLI version 446.0.0
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-446.0.0-linux-x86_64.tar.gz && \
    tar -xvzf google-cloud-sdk-446.0.0-linux-x86_64.tar.gz && \
    mv google-cloud-sdk /usr/local && \
    /usr/local/google-cloud-sdk/install.sh --quiet && \
    rm google-cloud-sdk-446.0.0-linux-x86_64.tar.gz


COPY scripts/ /usr/local/bin/
RUN chmod +x /usr/local/bin/run_auto_mount_in_pod.sh && chmod +x /usr/local/bin/run_get_disk_uuid_in_pod.sh
ENTRYPOINT ["/usr/local/bin/run_auto_mount_in_pod.sh"]
