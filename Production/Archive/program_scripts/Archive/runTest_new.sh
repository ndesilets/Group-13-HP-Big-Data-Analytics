#!/bin/sh

# This script is designed to facilitate the running of
# tests which will be monitored, the resulting data
# can be used to validate parameter setting effects

# Store connect string
DBUSER='whitlocn'
DBUSERPASSWORD='capPass'
DB='dbcap'

# Store passed arguments
logDir=$1
dataDir=$2
expScript=$3

echo expScript

# Establish connection and execute predefined queries
sqlplus /nolog  <<EOF  > ${logDir}/query.log
CONN ${DBUSER}/${DBUSERPASSWORD}@${DB}

${expScript}

EOF

echo 'Finished Testing Suite -- ' ${moduleName}

