# Postgres intro info

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

# Testing with cram

There's probably something more recent that might work better. Though for what is happening here [the cram tool written in Python](https://pypi.org/project/cram/) will work, despite not being updated in a while.

## Env vars

Passing environment variables into the tests is a bit weird. You can't just `source .env && cram path/to/test.t` or the env vars won't be passed along. You can, however, load the `.env` file in the cram test or before invoking it.

### Inside the test

This is the easier way imo. Just add something like this to the top of the file:

```
Load environment vars from .env file
  $ source "$TESTDIR/../.env"
```

`$TESTDIR` is an env var provided by cram, and it corresponds to the folder that the `.t` file resides in. In this example it is followed by the `..` to signify that the `.env` file is in the folder above the one that the test resides in.

### Before the test

This works as a workaround if you don't want to load env vars from inside the cram tests.

```
DATABASE_URL=$(source .env && echo $DATABASE_URL) cram tests/001-first-test/001-first-test.t
```

Which is fine for 1 or 2 env vars, but beyond that something else will be needed (not sure if that'll be an issue in this case).

## Creating new tests

- Create a new test by making a `.t` file with the commands to run.
  - IMPORTANT: Make sure there is an extra line return at the end of the file or the next steps won't work right.
- Run the test with a `-i` flag at the end, ex: `cram tests/my-test.t -i`.
- Inspect the results, if they are correct then choose "yes" to update the test file with the appropriate output.
- Add more tests and repeat running with `-i` as needed.

Comments are just lines that don't start with 2 spaces.

## Updating tests

If a test fails because it's output has changed, and that changed output is actually what we want now, then simply run the test with the `-i` flag as above in `Creating new tests` and accept the changes.

## Other things of interest

### $TESTDIR

When running a cram test there is an en var (`$TESTDIR`) that corresponds to the directory that the tests were executed from (or maybe something else but the equivalent of where it was executed from in this case).

### Testing `SELECT` access

If we're also testing inserts/deletes/updates in the same instance as selects it poses a problem: once we modify a table that can affect the results when querying it. An easy solution if we just want to test access is to do something like this:

```sql
SELECT 'some string value'
FROM schema.table
LIMIT 1;
```

This will fail if the role lacks the appropriate privileges, but will succeed and return just 1 row with the string value we specify if it succeeds.

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
