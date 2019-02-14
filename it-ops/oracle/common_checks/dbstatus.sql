--
-- Skrypt pokazujacy status wszystkich instancji danej bazy
--

set linesize 250
set verify off
set feedback off

col INST_ID for 99 heading Inst_ID
col NAME for a5
col STARTUP_TIME heading 'Startup' for a20
col ARCHIVER heading 'Arch'
col DATABASE_STATUS heading 'DBStatus'
col ACTIVE_STATE heading 'ActvState'
col BLOCKED heading 'Blk'
col INSTANCE_NAME for a8 heading 'Instance'
col HOST_NAME for a20
col VERSION for a12
col STATUS for a10
col THREAD# for 9999999 heading Thread#
col DATABASE_STATUS for a10
col HOST_NAME heading Hostname
col STATUS heading Status
col VERSION heading Version
col LOGINS headin Logins
col INSTANCE_ROLE heading 'Instance Role'
col SHUTDOWN_PENDING heading 'Shutd Pend' for a10
select INST_ID, INSTANCE_NAME, HOST_NAME, VERSION, STARTUP_TIME, STATUS, THREAD#, ARCHIVER, LOGINS, SHUTDOWN_PENDING, DATABASE_STATUS, INSTANCE_ROLE, ACTIVE_STATE, BLOCKED from gv$instance;

col NAME heading Name
col CURRENT_SCN for 9999999999999 heading 'Current SCN'
col DB_UNIQUE_NAME for a8 heading Unq_Name
col DATAGUARD_BROKER heading DGBroker
col GUARD_STATUS heading DGStatus for a8
col FORCE_LOGGING heading FrcLog for a6
col INST_ID for 99 heading Inst_ID
col FS_FAILOVER_OBSERVER_PRESENT heading Observer for a8
col FLASHBACK_ON for a12 heading FlashBack
col FS_FAILOVER_STATUS heading 'FS-Failover Status'
col DATABASE_ROLE heading 'Database Role'
col PROTECTION_MODE heading 'Protection Mode'
col LOG_MODE heading 'Log Mode'
select INST_ID, DBID, NAME, DB_UNIQUE_NAME, LOG_MODE, PROTECTION_MODE, DATABASE_ROLE, DATAGUARD_BROKER, GUARD_STATUS, FORCE_LOGGING, CURRENT_SCN, FLASHBACK_ON, FS_FAILOVER_STATUS, FS_FAILOVER_OBSERVER_PRESENT from gv$database;

select INST_ID, POOL, round(sum(BYTES)/1024/1024) as MB
 from gv$sgastat
 where POOL!=' '
 group by INST_ID, POOL
union all
select INST_ID, NAME pool, BYTES/1024/1024 as MB
 from gv$sgastat
 where NAME='buffer_cache'
 order by INST_ID, POOL;

select * from gv$resource_limit where resource_name in ('processes', 'sessions');
prompt

set verify on
set feedback on
