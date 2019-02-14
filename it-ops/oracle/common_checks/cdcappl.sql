set feedback off
set echo off
ALTER session set NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI:SS';
SET SERVEROUTPUT ON FORMAT WRAPPED;

COLUMN PUBLISHER_STATE HEADING 'Publisher|State' FORMAT A45
COLUMN MEMORY_USAGE HEADING 'Streams|Pool|% Used' FORMAT 999
COLUMN LAST_ENQUEUED_MSG HEADING 'Last|Enqueued|LCR No.' FORMAT 9999999999
COLUMN CNUM_MSGS HEADING 'Number|of LCRs|Enqueued' FORMAT 999999999
COLUMN QUEUE_NAME HEADING 'Queue Name' FORMAT A20
COLUMN SENDER_ADDRESS HEADING 'Sender Queue' FORMAT A15
COLUMN SENDER_NAME HEADING 'Capture|Process' FORMAT A20
COLUMN QUEUE_SCHEMA FORMAT A10
COLUMN UNBROWSED_MSGS HEADING UnbrowsedMSGs
COLUMN OVERSPILLED_MSGS HEADIN OverSpilledMSGs
COLUMN STATE for a20 heading State
COLUMN QUEUE_SCHEMA heading "Queue Sch"
COLUMN CNUM_MSGS heading "LCRs|Enqueued"
COLUMN NUM_MSGS heading "LCRs|to dequeue"

prompt **** Capture publisher status ****
select QUEUE_ID, QUEUE_SCHEMA, QUEUE_NAME, SENDER_NAME, NUM_MSGS, CNUM_MSGS, LAST_ENQUEUED_MSG, UNBROWSED_MSGS, OVERSPILLED_MSGS, MEMORY_USAGE, PUBLISHER_STATE from GV$BUFFERED_PUBLISHERS;

prompt
prompt **** Reader server status ****
col TOTAL_MESSAGES_DEQUEUED heading "LCRs dequeued"
col TOTAL_MESSAGES_SPILLED heading "LCRs spilled"
col APPLY_NAME heading "Apply name"
select INST_ID, SID, SERIAL#, APPLY_NAME, STATE, TOTAL_MESSAGES_DEQUEUED, TOTAL_MESSAGES_SPILLED from gv$STREAMS_APPLY_READER;

prompt
prompt **** Apply server status ****
col APPLIED_MESSAGE_NUMBER for 999999999999999 heading "Applied LCR|number"
col APPLIED_MESSAGE_CREATE_TIME heading "Applied LCR|create time"
col APPLY_TIME heading "LCR Apply time"
col COMMITSCN heading "Commit SCN" for 9999999999999
col MESSAGE_SEQUENCE heading "Applied Msg|seq no."
col ELAPSED_APPLY_TIME/100 heading "Apply|Elap [s]" for 999999
select INST_ID, SID, SERIAL#, STATE, APPLY_TIME, COMMITSCN, APPLIED_MESSAGE_NUMBER, MESSAGE_SEQUENCE, ELAPSED_APPLY_TIME/100, APPLIED_MESSAGE_CREATE_TIME from gv$STREAMS_APPLY_SERVER;

prompt
prompt **** Apply latency ****
select (apply_time-applied_message_create_time)*86400 "Msg apply latency [s]", (sysdate-apply_time)*86400 "Secs since last apply",
to_char(applied_message_create_time,'hh24:mi:ss dd/mm/yy') "Event creation",
to_char(apply_time,'hh24:mi:ss dd/mm/yy') "Apply time" from dba_apply_progress;

set feedback on
