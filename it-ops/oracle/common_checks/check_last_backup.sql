select DB_NAME, TO_CHAR(START_TIME,'dd/mm/yyyy hh24:mi') START_TIME, TO_CHAR(END_TIME,'dd/mm/yyyy hh24:mi') END_TIME, STATUS
  from RC_RMAN_BACKUP_JOB_DETAILS
  where START_TIME>SYSDATE-4
  and DB_NAME='CBD'
  order by START_TIME;
