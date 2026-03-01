# Use the ubuntu image as base, as it supports installing necessary tools easily
FROM ubuntu:24.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release && \
    # psql
    echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list && \
    curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg && \
    # azure cli
    mkdir -p /etc/apt/keyrings && \
    curl -fsLS https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg && \
    AZ_DIST=$(lsb_release -cs) && \
    echo "Types: deb" > /etc/apt/sources.list.d/azure-cli.sources && \
    echo "URIs: https://packages.microsoft.com/repos/azure-cli/" >> /etc/apt/sources.list.d/azure-cli.sources && \
    echo "Suites: ${AZ_DIST}" >> /etc/apt/sources.list.d/azure-cli.sources && \
    echo "Components: main" >> /etc/apt/sources.list.d/azure-cli.sources && \
    echo "Architectures: $(dpkg --print-architecture)" >> /etc/apt/sources.list.d/azure-cli.sources && \
    echo "Signed-by: /etc/apt/keyrings/microsoft.gpg" >> /etc/apt/sources.list.d/azure-cli.sources && \
    # install
    apt-get update && \
    apt-get install -y apache2-utils azure-cli postgresql-client && \
    # cleanup
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash"]