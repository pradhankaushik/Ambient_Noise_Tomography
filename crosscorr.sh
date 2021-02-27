#!/bin/bash
#set your path
path=/DATA/Kashmir_Noise_Tomo
#setting all the crosscorrelation pairs between stations
cd $path/data
n_stations=`ls | wc -l`
stations=`ls -d *`
#for (( i=0; i<$n_stations; i++ ))
for i in `seq 0 $n_stations`
do
for j in `seq $i $n_stations`
do
#i,j index will access the directores inside data
dir1=${stations[i]}
dir2=${stations[j]}
#common julian day in both directory 1 and directory 2
cd $dir1
ls *.BHZ | head -1 | awk -F "_" '{print $2}' | awk -F "" '{print $5$6$7}' > ../head.txt
ls *.BHZ| tail -1 | awk -F "_" '{print $2}' | awk -F "" '{print $5$6$7}' > ../tail.txt
cd ../$dir2
ls *.BHZ| head -1 | awk -F "_" '{print $2}' | awk -F "" '{print $5$6$7}' >> ../head.txt
ls *.BHZ| tail -1 | awk -F "_" '{print $2}' | awk -F "" '{print $5$6$7}' >> ../tail.txt
start_jday=`more head.txt | sort| tail -1`
end_jday=`more tail.txt | sort | head -1`
rm ../head.txt ../tail.txt
#Copying files from processed first directory
cd $path/processed/$dir1
for file in `ls *.BHZ`
do
jday=`echo $file | awk -F "_" '{print $2}' | awk -F "" '{print $5$6$7}'`
if [ "$jday" -ge "$start_jday" ] && [ "$jday" -le "$end_jday" ];then
#need to create a directory inside crosscor
cd $path/crosscor
mkdir $dir1-$dir2
#go to previous directory
cd -
cp $file $path/crosscor/$dir1-$dir2
fi
done
#Copying files from processed second directory
cd ../$dir2
for file in `ls *.BHZ`
do
jday=`echo $file | awk -F "_" '{print $2}' | awk -F "" '{print $5$6$7}'`
if [ "$jday" -ge "$start_jday" ] && [ "$jday" -le "$end_jday" ];then
cp $file $path/crosscor/$dir1-$dir2
fi
done
#Cross correlating files
cd $path/crosscor/$dir1-$dir2
rm c*
for day in `seq $start_jday $end_jday`
do
for hr in `seq 0 23`
do
if [ $hr -lt 10 ];then
hr=0$hr
fi
file1=`echo v*$day$hr* | awk -F " " '{print $1}'`
file2=`echo v*$day$hr* | awk -F " " '{print $2}'`
sac<<!
r $file1 $file2
rtr
rmean
correlate
qdp off
w prepend c
q
!
done #day
done #hour
done #looping over station pair
done #looping over station pair
#creating new directory inside ccstack to store cross-correlated files
mkdir $path/ccstack/$dir1-$dir2
cc_dir=`echo $dir2 | awk -F "_" '{print $1}'`
cp cv*$cc_dir* $path/ccstack/$dir1-$dir2
