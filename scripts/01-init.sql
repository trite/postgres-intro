CREATE SCHEMA sandbox_public;

CREATE TABLE sandbox_public.user_stuff (
  id SERIAL PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL
);

CREATE TABLE sandbox_public.non_critical_stuff (
    id SERIAL PRIMARY KEY,
    non_sensitive_data VARCHAR(255),
    user_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES sandbox_public.user_stuff(id)
);

CREATE TABLE sandbox_public.critical_stuff (
    id SERIAL PRIMARY KEY,
    sensitive_data VARCHAR(255),
    user_id INTEGER,
    FOREIGN KEY (user_id) REFERENCES sandbox_public.user_stuff(id)
);

CREATE USER very_powerful_user WITH SUPERUSER PASSWORD 'unlimitedcosmicpowah';

CREATE USER very_restricted_user PASSWORD 'weaksauce';
GRANT USAGE ON SCHEMA sandbox_public TO very_restricted_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE sandbox_public.user_stuff TO very_restricted_user;
GRANT SELECT ON TABLE sandbox_public.critical_stuff TO very_restricted_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE sandbox_public.non_critical_stuff TO very_restricted_user;

BEGIN;
  WITH new_user AS (
    INSERT INTO sandbox_public.user_stuff (first_name, last_name) VALUES ('Jane', 'Smith') RETURNING id
  ), ncs AS (
    INSERT INTO sandbox_public.non_critical_stuff (non_sensitive_data, user_id) 
    SELECT 'Unimportant data', id FROM new_user
  )
  INSERT INTO sandbox_public.critical_stuff (sensitive_data, user_id) 
  SELECT 'Confidential data', id FROM new_user;
COMMIT;
