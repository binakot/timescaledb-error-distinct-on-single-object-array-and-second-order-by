#!/bin/sh
set -e

psql -v ON_ERROR_STOP=0 -U "$POSTGRES_USER" <<-EOSQL

-- Create a simple table.
CREATE TABLE test (
    id INTEGER NOT NULL,
    time TIMESTAMPTZ NOT NULL,
    value TEXT
);
SELECT create_hypertable('test', 'time');

-- Insert some values.
INSERT INTO test (id, time, value)
VALUES (1, '2021-10-01 12:00:00', 'one-first'),
       (1, '2021-10-01 13:00:00', 'one-second'),
       (2, '2021-10-01 14:00:00', 'two-first'),
       (2, '2021-10-01 15:00:00', 'two-second'),
       (3, '2021-10-01 16:00:00', 'three-first'),
       (3, '2021-10-01 17:00:00', 'three-second');

-- Broken query.
SELECT DISTINCT ON (id) * FROM test
WHERE id IN (2)
ORDER BY id ASC, time DESC;

-- But works without `ORDER BY time`.
SELECT DISTINCT ON (id) * FROM test
WHERE id IN (2)
ORDER BY id ASC;

-- And even works when in `IN array` more than single value.
SELECT DISTINCT ON (id) * FROM test
WHERE id IN (2, 3)
ORDER BY id ASC, time DESC;

EOSQL
