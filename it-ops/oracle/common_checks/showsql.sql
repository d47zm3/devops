-- Listowanie kodu SQL wykonywanego w danym momencie przez sesje o podanym SID (&1) pracujaca wskazanej instancji (&2)
col SQL_TEXT for a90
col USER_IO_WAIT_TIME/1000000/60 heading IO_Wait|[min] for 9999.99
col CPU_TIME/1000000/60 heading CPU_Time|[min] for 9999.99
col DISK_READS for 99999999 heading Disk|Reads
col DIRECT_WRITES for 9999999 heading Direct|Writes
col BUFFER_GETS for 999999999 heading Buffer|Gets
col CLUSTER_WAIT_TIME/1000000/60 heading Clust_Wait|[min] for 9999.999
col ELAPSED_TIME/1000000/60 heading Elapsed|[min] for 9999.99
col USERS_EXECUTING heading Users|Exec for 99999
col EXECUTIONS heading Executed for 99999999
col OPTIMIZER_COST heading Optimiz|Cost for 999999999
col SORTS heading Sorts for 999999
select SQL_TEXT, DISK_READS, DIRECT_WRITES, BUFFER_GETS, USER_IO_WAIT_TIME/1000000/60, CLUSTER_WAIT_TIME/1000000/60, CPU_TIME/1000000/60, SORTS, ELAPSED_TIME/1000000/60, USERS_EXECUTING, EXECUTIONS, OPTIMIZER_COST from gv$sql 
 where SQL_ID=(SELECT SQL_ID from GV$SESSION where SID=&1 AND INST_ID=&2)
 and INST_ID=&2;
