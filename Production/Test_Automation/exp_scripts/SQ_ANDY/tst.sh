# Set up oracle env variables
export ORACLE_SID=capstone
export ORAENV_ASK=NO
. oraenv

loops=$1

dbUser="c##capstone"
password="capPass"
db="dbcap"

sql_files=`ls -1 *.SQL | sort`

echo -e '\n\n*******************************************************' >> result.log
echo -e '**   BEGIN AUTO  LOOPS: ${loops}\n'                          >> result.log
echo    '**   ' `date`                                                >> result.log
echo -e '*******************************************************\n\n' >> result.log

sqlplus ${dbUser}/${password}@${db} @auto.sql


sql_pids=""

#sqlplus ${dbUser}/${password}@${db} @start_monitor.sql &

#pause for 10 seconds to make sure the monitoring loop gets started
#sqlplus ${dbUser}/${password}@${db} @pause.sql

for i in $sql_files
do
  for (( j=1; j<=$loops; j++ ))
  do

    sqlplus ${dbUser}/${password}@${db} @${i} auto $j & 2>&1
     
    
    sql_pids+="$! "

  done;

done;

echo -e "\n\n wait for sql ${sql_pids}\n\n"

for i in $sql_pids
do
 wait $i
done;

echo -e  "\n\nsql done\n\n"

#sqlplus  ${dbUser}/${password}@${db} @end_monitor.sql

wait;

