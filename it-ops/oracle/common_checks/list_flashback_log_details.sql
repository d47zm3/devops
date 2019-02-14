--
-- List Flashback Log Details.
--
 
--SET PAUSE ON
--SET PAUSE 'Press Return to Continue'
SET PAGESIZE 60
SET LINESIZE 300
SET VERIFY OFF
 
COLUMN "Log NO" FOR 9,999
COLUMN "Thread No" FOR 99
COLUMN "Seq No" FOR 99
COLUMN name FOR A50
COLUMN "Size(GB)" FOR 999,999
COLUMN "First Chg No" FOR 999,999,999,999,999,999
 
ALTER SESSION
     SET nls_date_format='DD MON YYYY hh24:mi:ss'
/
 
SELECT
     log# as "Log No", 
     thread# as "Thread No",
     sequence# as "Seq No",
     name,
     bytes/1024/1024/1024 as "Size(GB)",
     first_change# as "First Chg No",
     first_time
FROM  
   v$flashback_database_logfile;
