#!/bin/bash

# wait for pg server to be ready
echo "Waiting for PostgreSQL to run..."
sleep 1
while ! /usr/bin/pg_isready -q
do
    sleep 1
    echo -n "."
done

# PostgreSQL running
echo "PostgreSQL running, initializing database."

# PostgreSQL user
#
# create postgresql user pggis

/sbin/setuser postgres /usr/bin/psql -c "CREATE USER spades with SUPERUSER PASSWORD 'spades';"
#/sbin/setuser postgres /usr/bin/psql -c "CREATE USER jmayer with SUPERUSER PASSWORD 'pggis';"

# == Auto restore dumps ==
#
# If we find some postgresql dumps in /data/restore, then we load it
# in new databases
shopt -s nullglob
for f in /data/restore/*.backup
do
	echo "Found database dump to restore : $f"
    DBNAME=$(basename -s ".backup" "$f")
    echo "Creating a new database $DBNAME.."
    /usr/bin/psql -U pggis -h localhost -c "CREATE DATABASE $DBNAME WITH OWNER = spades     ENCODING = 'UTF8'     TEMPLATE = template0    CONNECTION LIMIT = -1;" postgres
    /usr/bin/psql -U pggis -h localhost -w -c "CREATE EXTENSION postgis; CREATE EXTENSION http; drop type if exists texture; create type texture as (url text,uv float[][]);" $DBNAME
#    /usr/bin/psql -U pggis -h localhost -w -f /usr/share/postgresql/9.5/contrib/postgis-2.1/sfcgal.sql -d $DBNAME

    echo "Restoring database $DBNAME.."
    /usr/bin/pg_restore -U spades -h localhost -d $DBNAME -w "$f"
    echo "Restore done."
done

# == Auto restore SQL backups ==
#
# If we find some postgresql sql scripts /data/restore, then we load it
# in new databases
shopt -s nullglob
for f in /data/restore/*.sql
do
	echo "Found database SQL dump to restore : $f"
    DBNAME=$(basename -s ".sql" "$f")
    echo "Creating a new database $DBNAME.."
    /usr/bin/psql -U pggis -h localhost -c "CREATE DATABASE $DBNAME WITH OWNER = spades     ENCODING = 'UTF8'     TEMPLATE = template0    CONNECTION LIMIT = -1;" postgres
    /usr/bin/psql -U pggis -h localhost -w -c "CREATE EXTENSION postgis; CREATE EXTENSION http; drop type if exists texture; create type texture as (url text,uv float[][]);" $DBNAME
#    /usr/bin/psql -U pggis -h localhost -w -f /usr/share/postgresql/9.5/contrib/postgis-2.1/sfcgal.sql -d $DBNAME
    echo "Restoring database $DBNAME.."
    /usr/bin/psql -U spades -h localhost -d $DBNAME -w -f "$f"
    echo "Restore done."
done

# == create new database pggis ==
echo "Creating a new empty database..."
# create user and main database
/usr/bin/psql -U spades -h localhost -c "CREATE DATABASE spades WITH OWNER = spades     ENCODING = 'UTF8'     TEMPLATE = template0    CONNECTION LIMIT = -1;" postgres

# activate all needed extension in pggis database
/usr/bin/psql -U pggis -h localhost -w -c "CREATE EXTENSION postgis; CREATE EXTENSION http;  drop type if exists texture;
create type texture as (url text,uv float[][]);" spades
#/usr/bin/psql -U pggis -h localhost -w -f /usr/share/postgresql/9.5/contrib/postgis-2.1/sfcgal.sql -d pggis

echo "Database initialized. Connect from host with :"
echo "psql -h localhost -p <PORT> -U spades -W spades"
echo "Get <PORT> value with 'docker ps'"
