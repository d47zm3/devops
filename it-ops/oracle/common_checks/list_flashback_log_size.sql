--
-- List the Flashback Logging Size.
--
 
--SET PAUSE ON
--SET PAUSE 'Press Return to Continue'
SET PAGESIZE 60
SET LINESIZE 300
SET VERIFY OFF
 
SELECT 
     estimated_flashback_size/1024/1024/1024 "EST_FLASHBACK_SIZE(GB)" 
FROM 
     v$flashback_database_log;
