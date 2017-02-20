#!/bin/bash

# Usage statement
if [ ! $# == 1 ]; then
    echo 'Usage: ./prependSql.sh <directory>'
    exit 1
fi

targetDir=${1}

contents=`ls -1 ${targetDir}/*.SQL`

for file in $contents; do
    temp=`echo -e "alter session set container = dbcap\n$(cat ${file})"`
    cat $temp
done
