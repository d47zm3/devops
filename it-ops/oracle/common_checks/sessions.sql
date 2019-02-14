set echo off
set pause off
set feedback off
set linesize 200
set pages 50
set verify off
SET SERVEROUTPUT ON FORMAT WRAPPED;
prompt ***** Sposob uzycia: @sessions [Username] [Message string] ******
prompt *****************************************************************

col message for a90 heading Message
col sid for 9999
col inst_id for 9 heading 'Inst ID'
col username for a18 heading Username
col program for a38 heading Program
col blocking_session heading 'Blck SID' for 99999999
col blocking_instance heading 'Blck Inst' for 999999999
col event heading Event for a50
col serial# heading Serial# for 9999999
col logon_time heading 'Logon Time'
col sql_id heading 'SQL ID'
ALTER session set NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI';
set serveroutput on

prompt ***** Wszystkie aktywne sesje uzytkownika &1 ******

SELECT LOGON_TIME, INST_ID, SID, SERIAL#, SQL_ID, USERNAME, PROGRAM, EVENT, BLOCKING_SESSION, BLOCKING_INSTANCE FROM GV$SESSION
 WHERE USERNAME LIKE '&1' AND STATUS='ACTIVE' AND EVENT!='Streams AQ: waiting for messages in the queue'
 ORDER BY INST_ID, SID;

prompt
prompt ***** Dlugotrwale aktywne sesje uzytkownika &1 ******

SELECT INST_ID, SERIAL#, SID, SQL_ID, USERNAME, MESSAGE, ELAPSED_SECONDS "Elapsed_Sec", TIME_REMAINING "Remain_Sec" FROM GV$SESSION_LONGOPS
 WHERE SID IN (SELECT SID FROM GV$SESSION WHERE USERNAME LIKE '&1' AND STATUS='ACTIVE')
 AND TIME_REMAINING !=0
 AND MESSAGE LIKE '&2'
 ORDER BY START_TIME, INST_ID, SID;

prompt
set feedback on
set verify on
