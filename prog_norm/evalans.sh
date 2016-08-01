#!/bin/bash
RESULT=`grep 'count' out.log | sed -e 's/^\([0-9a-f]\+\).*/\1/g'`
if [ ${RESULT} = "0021cfc8" ] ; then
  echo 'Correct!'
  grep "count" out.log | sed -e 's/^.*count[^0-9]*\([0-9]\+\).*$/\1/g' | tee contest.score
else
  echo 'Wrong'
  exit 1
fi
