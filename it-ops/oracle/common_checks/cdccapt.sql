set feedback off
col STATE for a50 heading State
col STARTUP_TIME for a20 heading 'Startup Time'
col CAPTURE_NAME heading 'Capture Name' for a20
col INST_ID heading 'Inst ID'
col LOGMINER_ID heading 'Logminer ID'
col SERIAL# heading 'Serial#'
col LATENCY heading 'Redo Scan|Latency[s]' FORMAT 999999
col LATENCYENQ heading 'Enqueue|Latency[s]' FORMAT 999999
col SID for 9999
col INST_ID for 9
select INST_ID, SID, SERIAL#, CAPTURE_NAME, LOGMINER_ID, ((SYSDATE - CAPTURE_MESSAGE_CREATE_TIME)*86400) LATENCY, (ENQUEUE_TIME-ENQUEUE_MESSAGE_CREATE_TIME)*86400 LATENCYENQ,
       STARTUP_TIME, STATE from gv$streams_capture;

set feedback on
