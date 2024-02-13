# Postgres intro
This is meant as a very quick means to get up and running with Postgres for learning purposes. Steps in the next section explain getting up and running, and later on how to connect with a SQL client if you don't want to use the command line.

## Pre-requisites
There are a few pre-reqs to getting up and running.

### Docker
You'll need [Docker](https://www.docker.com/) installed first.

### Just
The commands in this repository require the [Just command runner](https://github.com/casey/just) to be installed first.

## Getting started
Start up the docker container:

```
just start
```

This will start up a copy of the latest Postgres database, after downloading it if you don't already have it cached locally.

Next, connect to it:

```
just connect
```

You should now see something like this:

```
$ just connect
docker-compose exec postgres psql -U myadmin
psql (15.3 (Debian 15.3-1.pgdg120+1))
Type "help" for help.

myadmin=#
```

Try creating a table, inserting some data, and then querying it:

```
-- Create the table:
CREATE TABLE my_table(id SERIAL, something TEXT, something_else INT);

-- Insert some data:
INSERT INTO my_table(something, something_else) VALUES ('foo', 42), ('bar', 84);

-- Select everything that is in the table
SELECT * FROM my_table;
```

Ex:
```
myadmin=# CREATE TABLE my_table(id SERIAL, something TEXT, something_else INT);
CREATE TABLE
myadmin=# INSERT INTO my_table(something, something_else) VALUES ('foo', 42), ('bar', 84);
INSERT 0 2
myadmin=# SELECT * FROM my_table;
 id | something | something_else
----+-----------+----------------
  1 | foo       |             42
  2 | bar       |             84
(2 rows)

myadmin=#
```

## Tutorial
At this point you're up and running enough to go through the [tutorial in the Postgres docs](https://www.postgresql.org/docs/current/tutorial.html). You can skip to `1.4. Accessing a Database` at this point since you do not need to install Postgres or set it up.

# Connecting to the database
The `just connect` command is a very easy way to instantly drop into the the postgres command line interface, but you'll likely want a better way to interact with the database. You can connect a client to server `localhost` or `127.0.0.1` on port `5432`. The username and password default as follows, and can be changed by simply updating the `docker-compose.yml` file and restarting the docker container with `just restart`:

```
POSTGRES_USER: myadmin
POSTGRES_PASSWORD: mysecretpassword
```

# Other Just commands
Start the server: `just start`
Stop the server: `just stop`
Restart the server: `just restart`
Open postgres inside the container to allow you to run commands: `just connect`
Delete the containers AND WIPE THE DB OUT COMPLETELY: `just hard-reset`
Factory resetting means deleting all and restarting: `just hard-reset start`

# "docker-compose" not found
If your `docker-compose` command isn't in your `PATH` env var, or if you want to use a custom install, edit this line in the `Justfile`:
```
dc := "docker-compose"
```