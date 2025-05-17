2️⃣ Set Environment

export ORACLE_SID=PORDDB
export ORACLE_HOME=/u01/app/oracle/product/19.0.0.0/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH


3️⃣ Start the Database in MOUNT Mode

sqlplus / as sysdba

SHUTDOWN IMMEDIATE;
STARTUP MOUNT;


4️⃣ Use NID to Change the DB Name

nid TARGET=/ DBNAME=GGPROD SETNAME=YES


Do you really want to change the database name from PORDDB to GGPROD? (Y/[N]):
→ Enter Y

set the new env nd create pfile and passwordfile

5️⃣ Shutdown and Startup in MOUNT Mode Again

SHUTDOWN IMMEDIATE;
STARTUP MOUNT;

6️⃣ Rename Datafiles and Logfiles to New Directory
🗂 Create new directories:

mkdir -p /u01/app/oracle/oradata/GGPROD/datafile
mkdir -p /u01/app/oracle/oradata/GGPROD/onlinelog
mkdir -p /u01/app/oracle/oradata/GGPROD/controlfile
mkdir -p /u01/app/oracle/fast_recovery_area/GGPROD/onlinelog
mkdir -p /u01/app/oracle/fast_recovery_area/GGPROD/controlfile


🚚 Move datafiles:

cp /u01/app/oracle/oradata/PORDDB/datafile/* /u01/app/oracle/oradata/GGPROD/datafile/

🚚 Move online log files:

cp /u01/app/oracle/oradata/PORDDB/onlinelog/* /u01/app/oracle/oradata/GGPROD/onlinelog/
cp /u01/app/oracle/fast_recovery_area/PORDDB/onlinelog/* /u01/app/oracle/fast_recovery_area/GGPROD/onlinelog/

🚚 Move control files:

cp /u01/app/oracle/oradata/PORDDB/controlfile/* /u01/app/oracle/oradata/GGPROD/controlfile/
cp /u01/app/oracle/fast_recovery_area/PORDDB/controlfile/* /u01/app/oracle/fast_recovery_area/GGPROD/controlfile/

7️⃣ Update File Locations in the Database
Return to SQL*Plus (still in MOUNT mode):

🔄 Rename Datafiles:

ALTER DATABASE RENAME FILE '/u01/app/oracle/oradata/PORDDB/datafile/o1_mf_system_n1p1gj3p_.dbf' TO '/u01/app/oracle/oradata/GGPROD/datafile/o1_mf_system_n1p1gj3p_.dbf';
ALTER DATABASE RENAME FILE '/u01/app/oracle/oradata/PORDDB/datafile/o1_mf_sysaux_n1p1hmcr_.dbf' TO '/u01/app/oracle/oradata/GGPROD/datafile/o1_mf_sysaux_n1p1hmcr_.dbf';
ALTER DATABASE RENAME FILE '/u01/app/oracle/oradata/PORDDB/datafile/o1_mf_undotbs1_n1p1jdjh_.dbf' TO '/u01/app/oracle/oradata/GGPROD/datafile/o1_mf_undotbs1_n1p1jdjh_.dbf';
ALTER DATABASE RENAME FILE '/u01/app/oracle/oradata/PORDDB/datafile/o1_mf_krupa_ts_n28bmxlq_.dbf' TO '/u01/app/oracle/oradata/GGPROD/datafile/o1_mf_krupa_ts_n28bmxlq_.dbf';
ALTER DATABASE RENAME FILE '/u01/app/oracle/oradata/PORDDB/datafile/o1_mf_users_n1p1jfmz_.dbf' TO '/u01/app/oracle/oradata/GGPROD/datafile/o1_mf_users_n1p1jfmz_.dbf';
🔄 Rename Redo Log Files:
sql
Copy
Edit
ALTER DATABASE RENAME FILE '/u01/app/oracle/oradata/PORDDB/onlinelog/o1_mf_1_n1p1kzqj_.log' TO '/u01/app/oracle/oradata/GGPROD/onlinelog/o1_mf_1_n1p1kzqj_.log';
ALTER DATABASE RENAME FILE '/u01/app/oracle/oradata/PORDDB/onlinelog/o1_mf_2_n1p1kzrf_.log' TO '/u01/app/oracle/oradata/GGPROD/onlinelog/o1_mf_2_n1p1kzrf_.log';
ALTER DATABASE RENAME FILE '/u01/app/oracle/oradata/PORDDB/onlinelog/o1_mf_3_n1p1kzss_.log' TO '/u01/app/oracle/oradata/GGPROD/onlinelog/o1_mf_3_n1p1kzss_.log';

ALTER DATABASE RENAME FILE '/u01/app/oracle/fast_recovery_area/PORDDB/onlinelog/o1_mf_1_n1p1l6lg_.log' TO '/u01/app/oracle/fast_recovery_area/GGPROD/onlinelog/o1_mf_1_n1p1l6lg_.log';
ALTER DATABASE RENAME FILE '/u01/app/oracle/fast_recovery_area/PORDDB/onlinelog/o1_mf_2_n1p1l807_.log' TO '/u01/app/oracle/fast_recovery_area/GGPROD/onlinelog/o1_mf_2_n1p1l807_.log';
ALTER DATABASE RENAME FILE '/u01/app/oracle/fast_recovery_area/PORDDB/onlinelog/o1_mf_3_n1p1l99x_.log' TO '/u01/app/oracle/fast_recovery_area/GGPROD/onlinelog/o1_mf_3_n1p1l99x_.log';

8️⃣ Update Control File Paths

ALTER SYSTEM SET CONTROL_FILES='/u01/app/oracle/oradata/GGPROD/controlfile/o1_mf_n1p1kwwo_.ctl','/u01/app/oracle/fast_recovery_area/GGPROD/controlfile/o1_mf_n1p1kx15_.ctl' SCOPE=SPFILE;

9️⃣ Restart the Database

SHUTDOWN IMMEDIATE;
STARTUP;
🔟 Verify
sql
Copy
Edit
SELECT name FROM v$database;
SELECT name FROM v$datafile;
SELECT member FROM v$logfile;
SELECT name FROM v$controlfile;
Make sure all file paths now point to /GGPROD/ and the DB name shows GGPROD.