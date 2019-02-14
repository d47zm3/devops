set pagesize 100

column file_name format a60
column tablespace_name format a15
column status format a10 heading Status
column t format 99,999,999.00 heading "Total MB"
column a format a4 heading "AExt"
column p format 990.00 heading "% Free"
column incby format 9,999.99 heading "IncBy MB"
column df.maxbytes/1048576 heading "MaxSize MB" for 99,999,999.99

SELECT df.file_name, df.tablespace_name, df.status, (df.bytes/1048576) t, (fs.s/df.bytes*100) p, decode (ae.y,1,'YES','NO') a, df.increment_by*8/1024 incby, df.maxbytes/1048576
 FROM dba_data_files df, (SELECT file_id,SUM(bytes) s
                           FROM dba_free_space
                           GROUP BY file_id) fs,
                         (SELECT file#, 1 y
                           FROM sys.filext$
                           GROUP BY file#) ae
 WHERE df.file_id = fs.file_id
 AND ae.file#(+) = df.file_id
 ORDER BY df.tablespace_name, df.file_id;

column FILE_NAME for a50
column a.BYTES/1024/1024 heading 'Total MB' for 999,999,999.99
column b.FREE_SPACE/1024/1024 heading 'Free MB' for 999,999,999.99
column a.MAXBYTES/1048576 heading 'MaxSize MB' for 999,999,999.99
column a.INCREMENT_BY*8/1024 format 9,999.99 heading "IncBy MB"
column AUTOEXTENSIBLE heading 'AExt' for a4
select a.FILE_NAME, a.TABLESPACE_NAME, a.STATUS, a.AUTOEXTENSIBLE, a.INCREMENT_BY*8/1024, a.BYTES/1024/1024, b.FREE_SPACE/1024/1024, a.MAXBYTES/1048576 from DBA_TEMP_FILES a, DBA_TEMP_FREE_SPACE b
 where a.TABLESPACE_NAME=b.TABLESPACE_NAME;

column t clear
column a clear
column p clear
column status clear
