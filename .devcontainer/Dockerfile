FROM mcr.microsoft.com/devcontainers/php:1-8.3-bookworm

# Remove the broken Yarn repository
RUN rm -f /etc/apt/sources.list.d/yarn.list

# Update packages and install MariaDB + PHP MySQL extension
RUN apt-get update && \
    apt-get install -y mariadb-server mariadb-client php8.3-mysql && \
    apt-get clean

EXPOSE 8000