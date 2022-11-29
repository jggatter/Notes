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