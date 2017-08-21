# Module pls
Oracle database fast parallel DML implementation
Based on article http://www.orafaq.com/node/2450 (parallel pl/sql implementation)

## How to use
Download archive.
Unzip to ~/prl directory.

Change prl_run_proc.func.sql script - replace example_table to you large table

set SQLPATH env
```bash
export SQLPATH=~/prl
```
Run SqlPlus
```bash
sqlplus schema/pass@host:1521/sid
```
Run 
```oraclesqlplus
@run
```



