#!/bin/bash
if diff answer result.dat ; then
  echo 'Correct!'
  grep "count" out.log | sed -e 's/^.*count[^0-9]*\([0-9]\+\).*$/\1/g' | tee contest.score
else
  echo 'Wrong'
  exit 1
fi
