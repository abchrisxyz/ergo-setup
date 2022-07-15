Docker based Ergo setup. Somewhat similar to [Ergo Bootstrap](https://github.com/ergoplatform/ergo-bootstrap) except it offers much less options and is not NixOS-based.

Install [Docker](https://docs.docker.com/engine/install/) and [Docker Compose](https://docs.docker.com/compose/install/), then follow the instructions below for the components you'd like to run.

> Containers are configured to expose certain ports for convenient access within a home lab context. Modify the `ports` values in the `docker-compose.yml` files if needed.

Note that the explorer stack doesn't include the utxo broadcaster yet (required for the explorer's mempool api).

## Node

```
# Volume and network expected by node compose file.
docker volume create ergo-node
docker network create ergo-node

# Starting the service
cd node
docker compose up -d

# Stopping the service (still from within the node directory)
# Using stop before/instead of down seems to cause less db corruption issues
docker compose stop node
docker compose down
```

## Explorer

Edit `build.sh` (or `build.bat` if using Windows) and set the `EXPLORER_VERSION` variable to the desired Explorer version. You can use any tag from the explorer repository: https://github.com/ergoplatform/explorer-backend.

For the UI, edit the `API` arg in `docker-compose.yml` to point to the (external) URL of your api service.

> If using another node than the one defined in this stack, edit the `master-nodes` field in  `explorer\explorer-backend.conf` to point it to your node.

```
# Run the build script
cd explorer
./build.sh

# Choose a password for the database
echo POSTGRES_PASSWORD=some-pw-you-can-choose > db/db.secret
# Same password but different env variable for the GraphQL service
echo DB_USER_PWD=some-pw-you-can-choose >> db/db.secret

# Create a named volume for Redis
docker volume create ergo_redis

# Start all services in one go...
docker compose up -d --build

# ...or only the ones you need
docker compose build db grabber api
docker compose up --no-start
docker compose start db grabber
docker compose start api

# Check their status
docker ps --filter name=explorer -a

# Stop all explorer services
docker compose down
# ...or
docker compose stop api grabber
docker compose stop db
```

### GraphQL

The graphql server will run over http on port 3001. To use it with clients requiring https, put it behind a reverse proxy.

### Database volume

Unlike the node, the database volume is mapped, not named. Mapped volumes make it easier to handle  Postresql upgrades.

This means you may have to edit the path in `explorer/docker-compose.yml` and ensure the specified path exists on your system:

```
services:
  db:
...
    volumes:
      # Mapped volume for easier Postgres upgrades.
      # Make sure the path exists or edit it here.
      # See also readme_pg_upgrade.md
      - /var/lib/explorer_pg/14/data:/var/lib/postgresql/data
...
```

### Initial sync

~~Syncing from scratch will take a long time (weeks). Two solutions:~~

~~1. Drop indexes and constraints from the database and restore them once initial sync is done.~~
~~2. Get a snapshot from someone~~

Sync performance seems to have improved significantly. There have been several reports of full syncs in 48h or less. Still, if in a hurry, above points remain valid.

### Database dump and restore
If wanting to backup your db, migrate it or provide a dump for someone else, we recommend the following:
```
docker exec -it explorer-db-1 pg_dump -Fc -v --schema=public --file /var/lib/postgresql/data/explorer.dmp --username=ergo ergo 
```
This will use the pg_restore present within the db container and save the dump to the mapped db volume. Note the `Fc` flag which outputs the dump in custom format resulting in smaller dump size and faster processing.

To restore, the db needs to be empty but with the schema loaded. Create a fresh db container by starting the db service only at first, no grabber, no utx-tracker.
Copy the dump file to the mapped db volume so that the db container can see it. Then run:

```
docker exec -it explorer-db-1 pg_restore -v --dbname=test --username=ergo --data-only /var/lib/postgresql/data/explorer.dmp
```
This will use the pg_restore present in the db container and read the dump from the mapped volume.

ALternatively, you have pg_restore or pgAdmin on the host or a remote and can connect to the db from the host/remote, you can load the dump from there. Just make sure your pg_restore's version is not behind the postgresql version running on the db container.




