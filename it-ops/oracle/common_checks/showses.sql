set echo off
set pause off
set feedback off
set linesize 200
set pages 35
set verify off

col sid for 9999
col inst_id for 999999 heading 'InstID'
col event for a45 heading Event
col username for a10 heading Username
col program for a30 heading Program
col blocking_session heading 'BlckSID' for 9999999
col blocking_instance heading 'BlckInst' for 99999999
col serial# heading Serial# for 9999999
col logon_time heading 'Logon Time'
col state heading State
col WAIT_CLASS heading 'Wait Class' for a15
col WAIT_TIME heading WTime for 9999
col SECONDS_IN_WAIT heading WSecs for 99999
ALTER session set NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI';

select LOGON_TIME, INST_ID, SID, SERIAL#, EVENT, USERNAME, STATE, WAIT_CLASS, WAIT_TIME, SECONDS_IN_WAIT, PROGRAM, BLOCKING_SESSION, BLOCKING_INSTANCE from gv$session where sid=&1 and inst_id=&2;

col FAILOVER_TYPE heading 'FailOver|Type'
col FAILOVER_METHOD heading 'FailOver|Method'
col FAILED_OVER heading 'Failed|Over' for a7
col SPID heading 'OS PID'
select p.SPID, s.FAILOVER_TYPE, s.FAILOVER_METHOD, s.FAILED_OVER from gv$process p, gv$session s
 where s.sid=&1 and s.inst_id=&2
 and   p.ADDR=s.PADDR;

select EVENT, TOTAL_WAITS, TOTAL_TIMEOUTS, TIME_WAITED, AVERAGE_WAIT, WAIT_CLASS from GV$SESSION_EVENT where SID=&1 and INST_ID=&2 order by TIME_WAITED desc;
set feedback on
set verify on
