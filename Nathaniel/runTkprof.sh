#!/bin/ksh

# Remove file extension and add random stamp
temp=$1
temp=${temp%%.*}
temp=${temp}_$RANDOM

# Set archive path
path=/u01/app/oracle/diag/rdbms/capstone/capstone/trace/Summary_Log

# Run tkprof with trcsess input
${ORACLE_HOME}/bin/tkprof $1 ${temp}.prf

# Read tkprof out to SQL console
/bin/cat ${temp}.prf

# Archive the tkprof output
/bin/mv ${temp}.prf ${path}/
