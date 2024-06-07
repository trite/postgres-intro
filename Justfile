# When no args are given, list out available commands
@_default:
  just --list

# If docker-compose IS NOT in your PATH env var, or if you want to use a
#   specific installation of docker-compose, set the path to it here.
# If docker-compose IS in your PATH, leave this line as is.
dc := "docker-compose"

# Start the postgres server
start:
  {{ dc }} up -d

# Stop the postgres server
stop:
  {{ dc }} down

# Restart the postgres server
restart:
  {{ dc }} restart

# Connect to the postgres server via the docker container
# No auth needed since you're connecting as if from inside the docker container
connect-docker:
  {{ dc }} exec postgres psql -U myadmin

# Connect to the postgres server from your local machine
connect-local:
  source .env && psql $DATABASE_URL

# DELETES ALL DATA
hard-reset:
  {{ dc }} down -v

# Wait for the postgres server to be ready
wait-for-db:
  DATABASE_URL=$(source .env && echo $DATABASE_URL) && ./scripts/wait-for-db.sh

# Run a test file
# Providing a 2nd param that is anything other than "nuh uh" will run the test in interactive mode
test testfile interactive="nuh uh": hard-reset start wait-for-db
  cram tests/{{ testfile }}.t {{ if interactive == "nuh uh" { "" } else { "-i" } }}

# Run all tests
test-all rebuild="nuh uh": 
  {{ if rebuild == "nuh uh" { "" } else { "just hard-reset start wait-for-db" } }}
  ./scripts/run-all-tests.sh

# Rebuild the containers and then run all tests
