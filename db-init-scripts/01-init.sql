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
GRANT USAGE, SELECT ON SEQUENCE sandbox_public.user_stuff_id_seq TO very_restricted_user;
GRANT SELECT ON TABLE sandbox_public.critical_stuff TO very_restricted_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE sandbox_public.non_critical_stuff TO very_restricted_user;
GRANT USAGE, SELECT ON SEQUENCE sandbox_public.non_critical_stuff_id_seq TO very_restricted_user;

CREATE OR REPLACE FUNCTION sandbox_public.attempt_create_user(
  first_name_param TEXT,
  last_name_param TEXT,
  sensitive_data_param TEXT,
  non_sensitive_data_param TEXT
)
RETURNS VOID
LANGUAGE PLPGSQL
AS $$
BEGIN
  WITH new_user AS (
    INSERT INTO sandbox_public.user_stuff (first_name, last_name)
    VALUES (first_name_param, last_name_param) RETURNING id
  ), ncs AS (
    INSERT INTO sandbox_public.non_critical_stuff (non_sensitive_data, user_id) 
    SELECT non_sensitive_data_param, id FROM new_user
  )
  INSERT INTO sandbox_public.critical_stuff (sensitive_data, user_id) 
  SELECT sensitive_data_param, id FROM new_user;
END;
$$;

SELECT sandbox_public.attempt_create_user(
	'Jane',
	'Smith',
	'Sensitive info!',
	'42 is the answer to...'
);

SELECT sandbox_public.attempt_create_user(
	'Somebody',
	'OneToldMe',
	'The world is gonna roll me',
	'I ain''t the sharpest tool in the shed'
);

SELECT sandbox_public.attempt_create_user(
	'Someone',
	'Somewhere',
	'Sensitive stuff! ROGGLE ROGGLE',
	'Taquitos are delicious'
);

