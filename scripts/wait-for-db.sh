#!/bin/bash

if [ -f .env ]; then
  # echo "Loading environment variables from .env file..."
  source .env
fi

# For debugging, uncomment the following line
# echo "DB URL: $DATABASE_URL"

if [ -z "$DATABASE_URL" ]; then
  echo "Error: DATABASE_URL environment variable is not set."
  exit 1
fi

echo "Waiting for database to become available..."

while ! psql "$DATABASE_URL" -c '\q' 2>/dev/null; do
  sleep 1
done

echo "Database is now available!"

exit 0

