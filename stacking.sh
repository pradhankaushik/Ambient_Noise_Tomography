#!/bin/bash
for dir in *
do
    cd ../ccstack/$dir
    count=0
    for file in `ls *.BHZ`
    do
    count=$((count + 1 ))
    mv $file corr-$count.sac
    done #files
done #directory
