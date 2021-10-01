# Error with DISTINCT ON in HYPERTABLE

## How to reproduce in playground with docker compose

```bash
$ docker-compose up
```

The broken query:

```sql
SELECT DISTINCT ON (id) * FROM test
WHERE id IN (2)
ORDER BY id ASC, time DESC;
```

Correct result:

```sql
 id |          time          |   value
----+------------------------+------------
  2 | 2021-10-01 15:00:00+00 | two-second
(1 row)
```

Error result:

```sql
ERROR:  column not present in index: 1
```

Query doesn't work when array contains a single value and using a second parameter in order by condition.
If we have two or more values in `array` then query works.
If we remove second condition in `order by` then query works.

## Summary

| PostgreSQL version | TimescaleDB version | Status | Docker image |
| --- | --- | --- | --- |
| 11.13 | - | ✅ | postgres:11 |
| 12.8 | - | ✅ | postgres:12 |
| 13.4 | - | ✅ | postgres:13 |
| 11.12 | 2.3.1 | ❌ | timescale/timescaledb:latest-pg11 |
| 12.8 | 2.4.2 | ❌ | timescale/timescaledb:latest-pg12 |
| 13.4 | 2.4.2 | ❌ | timescale/timescaledb:latest-pg13 |
| 12.8 | 2.2.0 | ✅ | current production environment |

We have to rewrite our queries to `WITH` clause for TimescaleDB upgrade from `2.2.0` to the latest...
