#!/bin/bash
split -l 324 nuclearlist.txt nuclearlistpart
c=0;
for i in nuclearlistpart*
do
   c=$(( $c + 1 ))
   cp $i Stack$c/nuclearlist.txt
done
rm nuclearlistpart*
