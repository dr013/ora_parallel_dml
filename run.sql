--alter session enable parallel dml;
alter session force parallel dml parallel 8;

set serveroutput on
set timing on

SELECT sum(column_value) from table(prl_run_proc(cursor(select /*+ parallel(tt 8) */ id from example_table tt)));
select ses_id, count(*) from example_table group by ses_id;

/*
    SES_ID   COUNT(*)
---------- ----------
       303        379
       556      21568
       528       3019
        38      16751
        45        494
       552      23517
       571      35042
       295      13903
8 rows selected
*/
