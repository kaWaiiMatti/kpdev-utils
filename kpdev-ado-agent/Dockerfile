# Source: https://learn.microsoft.com/en-us/azure/devops/pipelines/agents/docker?view=azure-devops#linux

FROM ubuntu:24.04
ENV TARGETARCH="linux-arm64"
# Also can be "linux-arm", "linux-arm64".

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release && \
    # Prepare Azure CLI repository
    mkdir -p /etc/apt/keyrings && \
    curl -fsLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg && \
    AZ_DIST=$(lsb_release -cs) && \
    echo "Types: deb" > /etc/apt/sources.list.d/azure-cli.sources && \
    echo "URIs: https://packages.microsoft.com/repos/azure-cli/" >> /etc/apt/sources.list.d/azure-cli.sources && \
    echo "Suites: ${AZ_DIST}" >> /etc/apt/sources.list.d/azure-cli.sources && \
    echo "Components: main" >> /etc/apt/sources.list.d/azure-cli.sources && \
    echo "Architectures: $(dpkg --print-architecture)" >> /etc/apt/sources.list.d/azure-cli.sources && \
    echo "Signed-by: /etc/apt/keyrings/microsoft.gpg" >> /etc/apt/sources.list.d/azure-cli.sources && \
    # Install applications
    apt-get update && \
    apt-get install -y azure-cli dotnet-sdk-10.0 git jq libicu74 && \
    # Podman and dependencies for running Docker commands in the agent container
    apt-get install -y podman uidmap slirp4netns fuse-overlayfs && \
    # Cleanup
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

# Delete default ubuntu user to avoid user id collision
RUN deluser --remove-home ubuntu

# Create agent user and set up home directory
RUN useradd -m -u 1000 -d /home/agent agent
RUN chown -R agent:agent /azp /home/agent

# Set up subuid and subgid ranges for the agent user to allow Podman to run containers as non-root
RUN usermod --add-subuids 100000-165535 --add-subgids 100000-165535 agent

# Set the DOCKER_HOST environment variable to point to the Podman socket for the agent user
ENV XDG_RUNTIME_DIR=/tmp/agent-runtime
ENV DOCKER_HOST=unix:///tmp/agent-runtime/podman/podman.sock

USER agent
# Another option is to run the agent as root.
# ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT [ "./start.sh" ]
