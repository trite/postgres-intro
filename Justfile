# When no args are given, list out available commands
@_default:
  just --list

# If docker-compose IS NOT in your PATH env var, or if you want to use a
#   specific installation of docker-compose, set the path to it here.
# If docker-compose IS in your PATH, leave this line as is.
dc := "docker-compose"

# If changing the `myadmin` username or `sandbox` database these need to be updated
user := "myadmin"
database := "sandbox"

# Start the postgres server
start:
  {{ dc }} up -d

# Stop the postgres server
stop:
  {{ dc }} down

# Restart the postgres server
restart:
  {{ dc }} restart

# Connect to the postgres server
# No auth needed since you're connecting as if from inside the docker container
connect:
  {{ dc }} exec postgres psql -U {{ user }} -d {{ database }}

# DELETES ALL DATA 
hard-reset:
  {{ dc }} down -v
