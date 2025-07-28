#!/bin/bash
# Install .NET 8
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt update
sudo apt install -y dotnet-sdk-8.0

# Install PostgreSQL 16
sudo sh -c "echo deb http://apt.postgresql.org/pub/repos/apt noble-pgdg main > /etc/apt/sources.list.d/pgdg.list"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update
sudo apt install -y postgresql-16

# Setup PostgreSQL
sudo -u postgres psql -c "CREATE USER leov WITH PASSWORD postgres;"
sudo -u postgres psql -c "CREATE DATABASE test OWNER leov;"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE test TO leov;"

