set verify off
set feedback off

col a.value/1024/1024 heading 'Allocated PGA [MB]' for 99999.99
select b.name, a.value/1024/1024 from gv$sesstat a, gv$statname b where b.statistic#=a.statistic# and a.statistic# in (37, 38) and value/1024/1024>10 and a.sid=&1 and a.inst_id=&2 group by b.name, a.value/1024/1024;

set verify on
set feedback on
