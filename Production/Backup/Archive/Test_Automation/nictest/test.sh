#!/bin/bash

for file in `ls | grep .sql`
do
	$name = $(`basename -s .sql $file`)
	echo "$name"
done


