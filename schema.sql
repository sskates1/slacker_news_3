CREATE TABLE articles (
  id serial PRIMARY KEY,
  title varchar(255) NOT NULL,
  url varchar(255) NOT NULL,
  user_id int NOT NULL,
  description text,
  score int NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE comments (
  id serial PRIMARY KEY,
  user_id varchar(255) NOT NULL,
  article_id int NOT NULL REFERENCES articles(id),
  parent_id int REFERENCES comments(id),
  comment text NOT NULL
);

CREATE TABLE users(
  id serial PRIMARY KEY,
  user_name varchar(255) NOT NULL,
  password varchar(25) NOT NULL,
  email varchar(255)
);


CREATE OR REPLACE FUNCTION DateDiff (units VARCHAR(30), start_t TIMESTAMP, end_t TIMESTAMP)
     RETURNS INT AS $$
   DECLARE
     diff_interval INTERVAL;
     diff INT = 0;
     years_diff INT = 0;
   BEGIN
     IF units IN ('yy', 'yyyy', 'year', 'mm', 'm', 'month') THEN
       years_diff = DATE_PART('year', end_t) - DATE_PART('year', start_t);

       IF units IN ('yy', 'yyyy', 'year') THEN
         -- SQL Server does not count full years passed (only difference between year parts)
         RETURN years_diff;
       ELSE
         -- If end month is less than start month it will subtracted
         RETURN years_diff * 12 + (DATE_PART('month', end_t) - DATE_PART('month', start_t));
       END IF;
     END IF;

     -- Minus operator returns interval 'DDD days HH:MI:SS'
     diff_interval = end_t - start_t;

     diff = diff + DATE_PART('day', diff_interval);

     IF units IN ('wk', 'ww', 'week') THEN
       diff = diff/7;
       RETURN diff;
     END IF;

     IF units IN ('dd', 'd', 'day') THEN
       RETURN diff;
     END IF;

     diff = diff * 24 + DATE_PART('hour', diff_interval);

     IF units IN ('hh', 'hour') THEN
        RETURN diff;
     END IF;

     diff = diff * 60 + DATE_PART('minute', diff_interval);

     IF units IN ('mi', 'n', 'minute') THEN
        RETURN diff;
     END IF;

     diff = diff * 60 + DATE_PART('second', diff_interval);

     RETURN diff;
   END;
   $$ LANGUAGE plpgsql;
