ALTER session set NLS_DATE_FORMAT='YYYY-MM-DD HH24:MI';
column username heading User format a10 
column program heading Running format a40
column status heading Status format a9
column spid heading 'OS PID' format a6
column lockwait heading LockWait format a8
column logon_time heading 'Logon Time'

SELECT sys.v_$session.username, sys.v_$session.logon_time,  sys.v_$session.program, sys.v_$session.status,
       sys.v_$session.lockwait, sys.v_$process.spid
FROM sys.v_$session, sys.v_$process
WHERE sys.v_$session.paddr = sys.v_$process.addr
AND sys.v_$session.username is not null
AND sys.v_$session.status='ACTIVE'
ORDER BY sys.v_$session.logon_time;
