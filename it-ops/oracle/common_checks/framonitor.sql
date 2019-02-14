--
-- Skrypt pokazujacy status wykorzystania FRA
--

set verify off
set feedback off

col name for a15
col space_limit/1024/1024 heading 'Space Limit [MB]' for 9999,999.99
col (space_limit-space_used)/1024/1024 heading 'Space Free [MB]' for 9999,999.99
col space_reclaimable/1024/1024 heading 'Reclaimable [MB]' for 9999,999.99
col pct_full heading '% full'
select name, space_limit/1024/1024, (space_limit-space_used)/1024/1024, space_reclaimable/1024/1024,
       -- to_char(space_limit, '999,999,999,999') as space_limit,
       -- to_char(space_limit - space_used + space_reclaimable, '999,999,999,999') as space_available,
       round((space_used - space_reclaimable)/space_limit * 100, 1) as pct_full
 from v$recovery_file_dest;

col PERCENT_SPACE_USED heading '% used'
col PERCENT_SPACE_RECLAIMABLE heading '% reclaimable'
col NUMBER_OF_FILES heading '# files'
select * from v$flash_recovery_area_usage;

col ESTIMATED_FLASHBACK_SIZE/1024/1024 heading 'Est Flashback size [MB]' for 9999,99
SELECT ESTIMATED_FLASHBACK_SIZE/1024/1024 FROM V$FLASHBACK_DATABASE_LOG;

set verify on
set feedback on
