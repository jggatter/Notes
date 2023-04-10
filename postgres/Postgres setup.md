#postgres #databases #sql #docker

## Docker image:
```zsh
docker pull postgres

# If you want to use port 5432 like in the example below
sudo systemctl stop postgresql

docker run --rm --name postgres -dit --p 5432:5432 -e POSTGRES_PASSWORD=password postgres
```
Additionally `--restart always` could be useful here

To connect: `psql -h localhost -U postgres`

## on Fedora:
https://docs.fedoraproject.org/en-US/quick-docs/postgresql/

```zsh
sudo dnf install postgresql-server postgresql-contrib

# To set it to start at boot, run:
sudo systemctl enable postgresql

# The database needs to be populated with initial data after installation.
# This creates the configuration files postgresql.conf and pg_hba.conf
sudo postgresql-setup --initdb --unit postgresql

# To start the postgresql server manually, run
sudo systemctl start postgresql

# Edit the host host line: replace ident with md5
# This helps a wider ranger of applications connect
sudo vim /var/lib/pgsql/data/pg_hba.conf

# Now you need to create a user and database for the user. This needs to be run # from a `postgres` user account on your system.
#sudo su - postgres && psql
sudo -u postgres psql
```

```postgresql
-- Set password of postgres account
\password postgres
-- create database
CREATE DATABASE mydatabase
```

```zsh
# Restart to take effect
sudo systemctl restart postgresql.service
```

## on macOS

```zsh
brew install postgres

# Might need to be referenced with version, e.g. postgres@14
brew start services postgres  

# If no users appear to exist:
createdb $USER
psql
```

If user postgres does not exist but is desired:
```postgresql
CREATE USER postgres SUPERUSER;
\password postgres -- set a password

CREATE DATABASE mydb WITH OWNER postgres;
-- Or alter existing
ALTER DATABASE mydb OWNER TO postgres; 
```

Log in as postgres user:
`psql -U postgres`

Drop all tables by dropping and recreating schema
```postgresql
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
```