-----------
--postgis--
-----------

--create geom
st_setsrid(st_makepoint(mytable."longitude"::float8, mytable."latitude"::float8), 4326)::geometry(Point, 4326) as geom

------
--db--
------
--show table sizes
select table_schema, table_name,pg_relation_size('"'||table_schema||'"."'||table_name||'"'), pg_size_pretty(pg_relation_size('"'||table_schema||'"."'||table_name||'"'))
from information_schema.tables
where table_schema = 'schemaname'
order by 3
;



--show active queries
select pid,substring(query from 1 for 100),state from pg_stat_activity where usename = 'username'

SELECT pg_cancel_backend({pid})
SELECT pg_terminate_backend({pid})

--show what locks a table
SELECT pid, relacl
FROM pg_locks l
JOIN pg_class t ON l.relation = t.oid AND t.relkind = 'r'
WHERE t.relname = 'tablename'

select * from lock_monitor
select * from pg_stat_activity

SELECT relname, last_vacuum, last_autovacuum, last_analyze, last_autoanalyze
FROM pg_stat_all_tables
WHERE schemaname = 'public'

---------------
--\list  /*show databases*/
--\connect dbname /*connect do db*/

--show schemas
select schema_name
from information_schema.schemata
--use schema
SET search_path TO myschema

--\dy /*list events*/
--\df /*list functions*/
--\dn /*list schemas*/
--\dt schema. /*show tables in schema*/
--\dv schema. /*show views in schema*/
--\e /*open editor*/
--\i /*execute script*/

--\x on   /*vertical view per record*/

--DELETE
DELETE  FROM
  basket a
USING basket b
WHERE
  a.id > b.id
  AND a.fruit = b.fruit;

----------------
-- copy to csv
----------------
\copy <schema.tablename> TO 'data.csv' DELIMITER ',' CSV HEADER;

---------------
-- upload from csv
------------------
\copy <schema.tablename> FROM 'data.csv' WITH (FORMAT CSV, DELIMITER ',', HEADER);

----------------------------
-- copy schema from db 2 db
----------------------------
pg_dump <source_db> --schema schema_name | psql -d <destination_db_name> -v ON_ERROR_STOP=1

-----------------------------------------
-- restore whole db from dump / backup --
-----------------------------------------
pg_restore -d <source_db> -c <backup/dump file> --c is for dropping objs in the db before uploading backup

-----------------------

-- CONNECT TO PYTHON --
-----------------------
import os
import psycopg2
POSTGRES_URI = os.getenv("POSTGRES_URI", "postgresql://username@host/db")
con = psycopg2.connect(POSTGRES_URI)
cur = con.cursor()
cur.execute('select ... ')

-- copy from python
f = open('data.csv', 'r')
LOAD_STATEMENT = """
    COPY tablename FROM STDIN WITH
        CSV
        HEADER
        DELIMITER AS ','
    """
cur.copy_expert(sql=LOAD_STATEMENT, file=f)
f.close()
