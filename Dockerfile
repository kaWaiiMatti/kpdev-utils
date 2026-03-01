# Use the ubuntu image as base, as it supports installing necessary tools easily
FROM ubuntu:24.04

# Install PostgreSQL client
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y curl gnupg lsb-release && \
    sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list' && \
    curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg && \
    apt-get update && \
    apt-get install -y postgresql-client && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Azure CLI
RUN apt-get update && \
    apt-get install -y curl && \
    curl -sL https://aka.ms/InstallAzureCLIDeb | bash && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash"]