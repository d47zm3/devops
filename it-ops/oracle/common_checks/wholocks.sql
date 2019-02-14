SELECT a.inst_id, a.sid, a.serial#
 FROM gv$session a, gv$locked_object b, dba_objects c
  WHERE b.object_id = c.object_id
  AND a.sid = b.session_id
  AND object_name='&1';
