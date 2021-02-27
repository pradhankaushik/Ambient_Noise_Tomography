#!/bin/bash
: '
This script will perform the the phase 1 of the data processing for single station as mentioned in Bensen_et_al-2007. Instrument response has been removed earlier and hence not considering it 
here. Mean and trend is removed; along with this band pass filter is applied to the signal.
Then, time domain normalization (here, 1-bit normalisation) and spectral whitening is applied. 
'

cd /DATA/India_data_From_SMitra/Kashmir_Noise_Tomography/SAC_data/processed/PAHL

for file in `ls *.BHZ`
do
sac<<!
r $file
qdp off
ch b 0.0
rmean
rtr
rglitches
bp co 0.0067 0.2 n 4 p 2
interpolate delta 1
write b.sac
q
!
#1-bit normalisation
gsac << EOF
r b.sac
sgn
w bb.sac
EOF
#spectral whitening
sac<<!
r bb.sac
whiten 
w wbb.sac
q
!
STAT=`saclhdr -KSTNM $file`
CHAN=`saclhdr -KCMPNM $file`
SLAT=`saclhdr -STLA $file`
SLONG=`saclhdr -STLO $file`
year=`echo $file | awk -F "_" '{print $2}'|awk -F "" '{print $1$2$3$4}'`
jday=`echo $file | awk -F "_" '{print $2}'|awk -F "" '{print $5$6$7}'`
hr=`echo $file | awk -F "_" '{print $2}'|awk -F "" '{print $8$9}'`
l=`echo $file | awk -F "_" '{print $2}'|awk -F "" '{print $10$11}'`
sac<<!
r bb.sac
ch KCMPNM $CHAN
ch KSTNM $STAT
ch STLA $SLAT
ch STLO $SLONG
ch nzyear $year nzjday $jday nzhour $hr nzmin $l nzsec 00
wh
q
!
mv wbb.sac ${file}_processed
rm b.sac bb.sac
done
