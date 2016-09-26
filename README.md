# pg_stats

This is an extension of PostgreSQL, which contains some customized statistics views.

## Installation

Execute `make install` on the contrib directory, or Put two files, pg_stats.control and pg_stats--1.0.sql, on the `~/share/postgresql/extension/` subdirectory.

Then, execute `CREATE EXTENSION pg_stats` on all databases you want to use this extension.

## TABLES

The view `pg_stat_tables` is created by joining with pg_stat_user_tables and pg_statio_user_tables, and is added some columns.

### Additional columns

| column           | description |
|:-----------------|:---|
| idx_scan_ratio | Ratio [%] of number of index scans to number of total scans, i.e., 100 * idx_scan/(seq_scan + idx_scan)|
| hit_ratio      | Ratio [%] of number of buffer hits to total number of read blocks, i.e., 100 * heap_blks_hit/(heap_blks_read + heap_blks_hit)|
| ins_ratio      | Ratio [%] of number of INSERT operations to number of total operations, i.e., 100 * n_tup_ins/(n_tup_ins + n_tup_upd + n_tup_del) |
| upd_ratio      | Ratio [%] of number of UPDATE operations to number of total operations, i.e., 100 * n_tup_upd/(n_tup_ins + n_tup_upd + n_tup_del) |
| del_ratio      | Ratio [%] of number of DELETE operations to number of total operations, i.e., 100 * n_tup_del/(n_tup_ins + n_tup_upd + n_tup_del) |
| hot_upd_ratio  | Ratio [%] of number of rows HOT updated to number of rows updated, i.e.,  100 * n_tup_hot_upd / n_tup_upd |
| table_size     | Disk space used by the specified fork ('main', 'fsm', 'vm') of the specified table  |
| total_size     | Total disk space used by the specified table, including all indexes and TOAST data   |


### Example

```
# SELECT * FROM pg_stat_tables;

-[ RECORD 1 ]-----+------------------------------
schemaname        | public
relname           | pgbench_accounts
relid             | 16391
seq_scan          | 1
idx_scan          | 194492
idx_scan_ratio    | 99
seq_tup_read      | 100000
idx_tup_fetch     | 194492
heap_blks_read    | 2011
heap_blks_hit     | 391145
hit_ratio         | 99.00
n_tup_ins         | 100000
n_tup_upd         | 97246
n_tup_del         | 0
ins_ratio         | 50.70
upd_ratio         | 49.30
del_ratio         | 0.00
n_tup_hot_upd     | 75326
hot_upd_ratio     | 77.46
table_size        | 16 MB
total_size        | 20 MB
last_vacuum       | 2016-09-25 07:33:06.279177+00
last_autovacuum   | 2016-09-26 03:48:55.294943+00
vacuum_count      | 1
autovacuum_count  | 1
last_analyze      | 2016-09-25 07:33:06.32018+00
last_autoanalyze  | 2016-09-26 03:48:01.615811+00
analyze_count     | 1
autoanalyze_count | 7
-[ RECORD 2 ]-----+------------------------------
schemaname        | public
relname           | pgbench_branches
relid             | 16394
seq_scan          | 136287
idx_scan          | 18853
--- continue ---
``` 


## INDEXES

The view `pg_stat_indexes` is created by joining with pg_stat_user_indexes and pg_statio_user_indexes, and is added some columns.


### Additional columns

| column           | description |
|:-----------------|:---|
| idx_hit_ratio  | Ratio [%] of number of buffer hits to number of all index read, i.e., 100 * idx_blks_hit/(idx_blks_read + idx_blks_hit)  |
| index_size     | Disk space used by the specified fork ('main', 'fsm') of the specified index   |


### Example


```
# SELECT * FROM pg_stat_indexes;
-[ RECORD 1 ]-+----------------------
schemaname    | public
relname       | pgbench_accounts
indexrelname  | pgbench_accounts_pkey
relid         | 16391
idx_scan      | 194492
idx_tup_read  | 221404
idx_tup_fetch | 194492
idx_blks_read | 551
idx_blks_hit  | 465398
idx_hit_ratio | 99
index_size    | 4408 kB
-[ RECORD 2 ]-+----------------------
schemaname    | public
relname       | pgbench_branches
indexrelname  | pgbench_branches_pkey
relid         | 16394
idx_scan      | 18853
idx_tup_read  | 946621
idx_tup_fetch | 18853
idx_blks_read | 2
idx_blks_hit  | 19416
idx_hit_ratio | 99
index_size    | 16 kB
-[ RECORD 3 ]-+----------------------
schemaname    | public
relname       | pgbench_tellers
indexrelname  | pgbench_tellers_pkey
relid         | 16388
idx_scan      | 19775
idx_tup_read  | 533645
idx_tup_fetch | 17428
idx_blks_read | 5
idx_blks_hit  | 27006
idx_hit_ratio | 99
index_size    | 40 kB
```

## USERS

The view `pg_stat_users` shows login time of each user. 


| column         | description |
|:---------------|:---|
| dattname     | Name of the database this backend is connected to  |
| usename      | Name of the user logged into this backend    |
| pid          | Process ID of this backend   |
| backend_start| Time when this process was started, i.e., when the client connected to the server   |
| login_time   | How long this backend is running  |


### Example

```
# SELECT * FROM pg_stat_users;
 datname  | usename | pid  |         backend_start         |  login_time  
----------+---------+------+-------------------------------+--------------
 sampledb | vagrant | 4972 | 2016-09-26 03:32:06.782921+00 | 00:05:09.257
 sampledb | vagrant | 4988 | 2016-09-26 03:35:34.716738+00 | 00:01:41.324
 sampledb | vagrant | 4998 | 2016-09-26 03:37:11.236835+00 | 00:00:04.804
 sampledb | vagrant | 4999 | 2016-09-26 03:37:11.239046+00 | 00:00:04.801
 sampledb | vagrant | 5000 | 2016-09-26 03:37:11.240234+00 | 00:00:04.8
 sampledb | vagrant | 5001 | 2016-09-26 03:37:11.241369+00 | 00:00:04.799
(6 rows)
```


## QUERIES

The view `pg_stat_queries` shows queries and their durations.


| column         | description |
|:---------------|:---|
| dattname     | Name of the database this backend is connected to  |
| usename      | Name of the user logged into this backend    |
| pid          | Process ID of this backend   |
| duration     | How long this query is running |
| waiting      | True if this backend is currently waiting on a lock |
| query        | Text of this backend's most recent query |


### Example

```
# SELECT * FROM pg_stat_queries;
 datname  | usename | pid  |   duration   | waiting |                                   query                                    
----------+---------+------+--------------+---------+----------------------------------------------------------------------------
 sampledb | vagrant | 4988 | 00:01:42.832 | f       | BEGIN;
 sampledb | vagrant | 4998 | 00:00:00.004 | t       | UPDATE pgbench_branches SET bbalance = bbalance + -4057 WHERE bid = 1;
 sampledb | vagrant | 4999 | 00:00:00.004 | f       | END;
 sampledb | vagrant | 5000 | 00:00:00.001 | f       | UPDATE pgbench_accounts SET abalance = abalance + -1378 WHERE aid = 62207;
 sampledb | vagrant | 5001 | 00:00:00.002 | t       | UPDATE pgbench_branches SET bbalance = bbalance + 550 WHERE bid = 1;
(5 rows)
```


## LONG TRANSACTIONS

The view `pg_stat_long_trx` catches long transactions.


| column         | description |
|:---------------|:---|
| pid          | Process ID of this backend.  |
| waiting      | True if this backend is currently waiting on a lock. |
| duration     | How long this transaction is running. |
| query        | Text of this backend's most recent query. |


### Example

```
# SELECT * FROM pg_stat_long_trx;
 pid  | waiting |   duration   |                                 query                                  
------+---------+--------------+------------------------------------------------------------------------
 4988 | t       | 00:00:34.031 | UPDATE test SET id = 10;
 5026 | f       | 00:05:43.063 | LOCK test;
 5054 | t       | 00:00:00.003 | UPDATE pgbench_branches SET bbalance = bbalance + -3093 WHERE bid = 1;
 5055 | f       | 00:00:00.002 | UPDATE pgbench_tellers SET tbalance = tbalance + -1561 WHERE tid = 1;
 5056 | f       | 00:00:00.001 | SELECT abalance FROM pgbench_accounts WHERE aid = 42689;
 5057 | f       | 00:00:00.007 | END;
(6 rows)
```

## WAITING LOCKS

The view `pg_stat_waiting_locks` shows waiting locks.

| column         | description |
|:---------------|:---|
| locktype     | Type of the lockable object |
| relname      | Name of the table, index, view, etc. |
| pid          | Process ID of this backend |
| mode         | Name of the lock mode held or desired by this process |
| query        | Text of this backend's most recent query |
| duration     | How long this lock is waiting |

### Example

```
# SELECT * FROM pg_stat_waiting_locks;
   locktype    | relname | pid  |       mode       | query  |   duration   
---------------+---------+------+------------------+--------+--------------
 relation      | test    | 4988 | RowExclusiveLock | UPDATE | 00:01:02.087
 transactionid |         | 5061 | ShareLock        | UPDATE | 00:00:00.001
 transactionid |         | 5063 | ShareLock        | UPDATE | 00:00:00.006
 transactionid |         | 5064 | ShareLock        | UPDATE | 00:00:00.01
(4 rows)
``` 
