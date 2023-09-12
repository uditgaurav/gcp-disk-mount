FROM ubuntu:latest

ENV DEBIAN_FRONTEND=non-interactive

RUN apt-get update \
    && apt-get install -y \
    openssh-client \
    curl \
    bash \
    && rm -rf /var/lib/apt/lists/*

RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
    && apt-get update -y && apt-get install google-cloud-sdk -y

COPY scripts/run_in_pod.sh /usr/local/bin/run_in_pod.sh

RUN chmod +x /usr/local/bin/run_in_pod.sh

ENTRYPOINT ["/usr/local/bin/run_in_pod.sh"]
