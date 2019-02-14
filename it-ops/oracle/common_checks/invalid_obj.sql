set feedback on
set verify on
col object_name for a50
select owner, object_name, object_type from dba_objects where status!='VALID' order by owner,object_type;
--select owner, object_name, object_type from dba_objects where owner='UFG_AC' and status!='VALID' order by object_type;
--select owner, object_name, object_type from dba_objects where owner='SYS' and status!='VALID' order by object_type;
--select owner, object_name, object_type from dba_objects where owner='CDCPUB' and status!='VALID' order by object_type;
