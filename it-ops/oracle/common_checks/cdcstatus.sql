set feedback off
set echo off
ALTER session set NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI';
SET SERVEROUTPUT ON FORMAT WRAPPED;
exec DBMS_OUTPUT.NEW_LINE;
col error_message for a50
col APPLY_USER for a10
col APPLY_CAPTURED head 'Apply|Captured' for a8
prompt ************** Status procesu APPLY ******************
select APPLY_USER, APPLY_NAME, QUEUE_NAME, APPLY_CAPTURED, STATUS, ERROR_MESSAGE from dba_apply;

col TOTAL_APPLIED head 'Applied' for 99999999
col TOTAL_WAIT_COMMITS head 'Wait|Commits' for 99999999
col TOTAL_ADMIN head 'Admin' for 99999999
col TOTAL_ASSIGNED head 'Assigned' for 99999999
col TOTAL_RECEIVED head 'Received' for 99999999
col TOTAL_IGNORED head 'Ignored' for 99999999
col TOTAL_ROLLBACKS head 'Rollbacks' for 99999999
col TOTAL_ERRORS head 'Errors' for 99999999
col ELAPSED_SCHEDULE_TIME head 'Elap Sched|Time'
col APPLY_NAME for a22
col STATE for a10
col STARTUP_TIME for a16 heading 'Startup Time'
select INST_ID, SID, STATE, APPLY_NAME, TOTAL_APPLIED, TOTAL_WAIT_COMMITS, TOTAL_ADMIN, TOTAL_ASSIGNED, TOTAL_RECEIVED, TOTAL_ERRORS, TOTAL_ROLLBACKS, TOTAL_IGNORED, TOTAL_ROLLBACKS ELAPSED_SCHEDULE_TIME, STARTUP_TIME from GV$STREAMS_APPLY_COORDINATOR;

prompt
prompt *************** Status procesu CAPTURE *******************
col capture_user for a10
col capture_name for a22
col queue_name for a22
col start_scn for 9999999999999
col first_scn for 9999999999999
col captured_scn for 9999999999999
col applied_scn for 9999999999999
col required_checkpoint_scn for 9999999999999 heading 'Req Ckpt SCN'
select CAPTURE_NAME, QUEUE_NAME, CAPTURE_USER, START_SCN, FIRST_SCN, CAPTURED_SCN, APPLIED_SCN, REQUIRED_CHECKPOINT_SCN, STATUS, ERROR_MESSAGE from dba_capture;

prompt
prompt ************** Status procesu CAPTURE dla Change Set *****************
col CAPTURE_ENABLED heading 'Capture|Enabled'
col CAPTURE_ERROR heading 'Capture|Error'
col CAPTURE_ENABLED for a7
col CAPTURE_ERROR for a7
col PURGING for a7

select SET_NAME, CHANGE_SOURCE_NAME, CAPTURE_ENABLED, CAPTURE_NAME, CAPTURE_ERROR, APPLY_NAME, QUEUE_NAME, PURGING from change_sets;

set feedback on
