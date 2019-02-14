col PATH for a50
col NAME for a30
select GROUP_NUMBER, TOTAL_MB, NAME, FAILGROUP, PATH, STATE from v$asm_disk order by GROUP_NUMBER, NAME;
select GROUP_NUMBER, NAME, TYPE, TOTAL_MB, FREE_MB, STATE from v$asm_diskgroup;
