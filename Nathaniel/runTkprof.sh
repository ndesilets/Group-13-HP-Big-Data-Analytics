#!/bin/ksh

# Remove file extension and store archive path
temp=$1
temp=${temp%%.*}
path=/u01/app/oracle/diag/rdbms/capstone/capstone/trace/Summary_Log

# Run tkprof with trcsess input
${ORACLE_HOME}/bin/tkprof $1 ${temp}.prf

# Make file backup and add unique timestamp id
/bin/cp ${temp}.prf ${path}

# Read tkprof out to SQL console
/bin/cat ${temp}.prf

# Trying to rename the tkprof output file with unique stamp
#/bin/mv ${path}/${temp}.prf ${path}/$(date +"$H_%M_"${temp}.prf)
