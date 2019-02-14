select distinct
a.tablespace_name,
SUM(a.bytes)/1024/1024 "Used Size MB",
SUM(decode(b.maxextend, null, A.BYTES/1024/1024, b.maxextend*8192/1024/1024)) "Max Size Mb",
(SUM(a.bytes)/1024/1024 - round(c."Free"/1024/1024)) "Total Used MB",
(SUM(decode(b.maxextend, null, A.BYTES/1024/1024, b.maxextend*8192/1024/1024)) - (SUM(a.bytes)/1024/1024 - round(c."Free"/1024/1024))) "Total Free MB",
round(100*(SUM(a.bytes)/1024/1024 - round(c."Free"/1024/1024))/(SUM(decode(b.maxextend, null, A.BYTES/1024/1024, b.maxextend*8192/1024/1024)))) "Used Percentage"
from
dba_data_files a,
sys.filext$ b,
(SELECT d.tablespace_name , sum(nvl(c.bytes,0)) "Free" FROM dba_tablespaces d,DBA_FREE_SPACE c where d.tablespace_name = c.tablespace_name(+) group by d.tablespace_name) c
where a.file_id = b.file#(+)
and a.tablespace_name = c.tablespace_name
GROUP by a.tablespace_name, c."Free"/1024
order by a.tablespace_name;
---order by round(100*(SUM(a.bytes)/1024/1024 - round(c."Free"/1024/1024))/(SUM(decode(b.maxextend, null, A.BYTES/1024/1024, b.maxextend*8192/1024/1024)))) desc;
