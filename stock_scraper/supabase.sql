
-- Run these in the SQL Editor on Supabase

CREATE TABLE articles (
    id BIGINT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    url TEXT UNIQUE NOT NULL,
    stock_symbol TEXT NOT NULL,
    title TEXT,
    author TEXT,
    published_date TEXT,
    content TEXT,
    scraped_at TIMESTAMPTZ NOT NULL -- Ensures every row has a timestamp
);

create extension if not exists pg_cron;

select cron.schedule(
    'delete_old_articles',  -- Unique job name
    '0 */6 * * *',  -- Runs every hour (modify as needed)
    $$ delete from articles where scraped_at < now() - interval '24 hours' $$
);


SELECT cron.schedule(
    'delete_old_articles_test',  -- Unique job name
    '*/5 * * * *',  -- Runs every 5 minutes
    $$ DELETE FROM articles WHERE scraped_at < NOW() - INTERVAL '5 minutes' $$
);

SELECT cron.unschedule('delete_old_articles_test');

SELECT * FROM cron.job;

DROP TABLE IF EXISTS articles;