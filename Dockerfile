# Use an official Ubuntu as a parent image
FROM ubuntu:latest

# Set the maintainer label
LABEL maintainer="example@example.com"

# Set environment variables to non-interactive (this prevents some prompts)
ENV DEBIAN_FRONTEND=non-interactive

# Run package updates and install packages
RUN apt-get update \
    && apt-get install -y \
    openssh-client \
    curl \
    bash \
    && rm -rf /var/lib/apt/lists/*

# Copy the script into the container
COPY scripts/run_in_pod.sh /usr/local/bin/run_in_pod.sh

# Make the script executable
RUN chmod +x /usr/local/bin/run_in_pod.sh

# Set the script as the default entry point
ENTRYPOINT ["/usr/local/bin/run_in_pod.sh"]
