set verify off
set feedback off
set pages 50

col value/1024/1024 heading 'Allocated PGA [MB]' for 9999.99
col inst_id heading InstID
prompt Top 10 PGA usage:
select * from (select inst_id, sid, value/1024/1024 from gv$sesstat where inst_id=1 and statistic#=38 and value/1024/1024>10 order by inst_id, value/1024/1024 desc) where rownum<=10;
select * from (select inst_id, sid, value/1024/1024 from gv$sesstat where inst_id=2 and statistic#=38 and value/1024/1024>10 order by inst_id, value/1024/1024 desc) where rownum<=10;

col sum(value/1024/1024) heading 'Total allocated PGA [MB]' for 99999.99
select inst_id, sum(value/1024/1024) from gv$sesstat where statistic#=38 group by inst_id order by inst_id;

set verify on
set feedback on
