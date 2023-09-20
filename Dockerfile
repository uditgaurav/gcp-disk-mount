FROM alpine:3.17.4

RUN apk --update add \
        sudo \
        curl \
        tar \
        openssh-client \
        python3 \
        py3-pip \
        && ln -sf python3 /usr/bin/python

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update && \
    apt-get install -y google-cloud-sdk

# Installing Google Cloud SDK CLI version 446.0.0
RUN curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-446.0.0-linux-x86_64.tar.gz && \
    tar -xvzf google-cloud-sdk-446.0.0-linux-x86_64.tar.gz && \
    mv google-cloud-sdk /usr/local && \
    /usr/local/google-cloud-sdk/install.sh --quiet && \
    rm google-cloud-sdk-446.0.0-linux-x86_64.tar.gz


COPY scripts/run_in_pod.sh /usr/local/bin/run_in_pod.sh
RUN chmod +x /usr/local/bin/run_in_pod.sh
ENTRYPOINT ["/usr/local/bin/run_in_pod.sh"]
