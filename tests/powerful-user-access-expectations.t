Load environment vars from .env file
  $ source "$TESTDIR/../.env"

User should be able to SELECT on the `sandbox_public.user_stuff` table.

  $ psql $DATABASE_URL -c "
  > SET ROLE very_powerful_user;
  > 
  > SELECT 'it works'
  > FROM sandbox_public.user_stuff
  > LIMIT 1;
  > "
  SET
   ?column? 
  ----------
   it works
  (1 row)
  

User should be able to INSERT into the `sandbox_public.user_stuff` table.

  $ psql $DATABASE_URL -c "
  > SET ROLE very_powerful_user;
  > 
  > INSERT INTO sandbox_public.user_stuff (first_name, last_name) VALUES ('John', 'Doe')
  > "
  SET
  INSERT 0 1

User should be able to UPDATE the `sandbox_public.user_stuff` table.
  $ psql $DATABASE_URL -c "
  > SET ROLE very_powerful_user;
  > 
  > UPDATE sandbox_public.user_stuff SET first_name = 'Jane' WHERE id = 1
  > "
  SET
  UPDATE 1

User should be able to SELECT on the `sandbox_public.non_critical_stuff` table.
This just selects a string if it works, but will error if not.

  $ psql $DATABASE_URL -c "
  > SET ROLE very_powerful_user;
  > 
  > SELECT 'it works'
  > FROM sandbox_public.non_critical_stuff 
  > LIMIT 1;
  > "
  SET
   ?column? 
  ----------
   it works
  (1 row)
  

User should be able to INSERT into the `sandbox_public.non_critical_stuff` table.
  $ psql $DATABASE_URL -c "
  > SET ROLE very_powerful_user;
  > 
  > INSERT INTO sandbox_public.non_critical_stuff (non_sensitive_data)
  > VALUES ('This is not a secret');
  > "
  SET
  INSERT 0 1

User should be able to UPDATE the `sandbox_public.non_critical_stuff` table.

  $ psql $DATABASE_URL -c "
  > SET ROLE very_powerful_user;
  > 
  > UPDATE sandbox_public.non_critical_stuff
  > SET non_sensitive_data = 'This is not a secret either'
  > WHERE id = 1;
  > "
  SET
  UPDATE 1


User should be able to SELECT on the `sandbox_public.critical_stuff` table.

  $ psql $DATABASE_URL -c "
  > SET ROLE very_powerful_user;
  > 
  > SELECT 'it works'
  > FROM sandbox_public.critical_stuff
  > LIMIT 1
  > "
  SET
   ?column? 
  ----------
   it works
  (1 row)
  

User should be able to INSERT into the `sandbox_public.critical_stuff` table.

  $ psql $DATABASE_URL -c "
  > SET ROLE very_powerful_user;
  > 
  > INSERT INTO sandbox_public.critical_stuff (sensitive_data, user_id)
  > VALUES ('This is a secret', 1)
  > "
  SET
  INSERT 0 1

User should be able to UPDATE the `sandbox_public.critical_stuff` table.

  $ psql $DATABASE_URL -c "
  > SET ROLE very_powerful_user;
  > 
  > UPDATE sandbox_public.critical_stuff
  > SET sensitive_data = 'This is a secret'
  > WHERE id = 1;
  > "
  SET
  UPDATE 1

