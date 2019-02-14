--
-- List Flashback Database Restore Points
--
 
--SET PAUSE ON
--SET PAUSE 'Press Return to Continue'
SET PAGESIZE 60
SET LINESIZE 300
SET VERIFY OFF
 
COLUMN scn FOR 999,999,999,999,999
COLUMN Incar FOR 99
COLUMN name FOR A25
COLUMN storage_size FOR 999,999,999,999
COLUMN guarantee_flashback_database FOR A3
 
SELECT 
      database_incarnation# as Incar,
      scn,
      name,
      time,
      storage_size,
      guarantee_flashback_database
FROM 
      v$restore_point;
