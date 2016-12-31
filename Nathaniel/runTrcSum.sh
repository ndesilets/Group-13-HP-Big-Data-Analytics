#!/bin/sh

# This script is designed to take a directory of trace files
# generated from an event code, compile them with trcsess,
# and then take the resulting single file and run it through
# tkprof to summarize the results.

# Check the correct usage
if [ "$#" -ne 1 ]; then
    echo "Correct Usage: runTrcSum.sh <output>"
else
  # Check for empty directory
  if [ -d "$dir" ] && files=$(ls -qAL -- "$dir") && [ -z "$files" ]; then
    echo "No files in directory, verify trace file existance."
  else
    echo "Executing Trace Summary ..."
    trcsess output=$1.sess service=dbcap.cv.hp.com *.trc
    tkprof $1.sess $1.prof
 fi
fi
