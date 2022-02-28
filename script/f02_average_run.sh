#!/bin/bash

mkdir run_average
cd run_average
3dMean -overwrite -prefix Av_Nulled_intemp.nii ../run1/Nulled_intemp.nii ../run2/Nulled_intemp.nii ../run3/Nulled_intemp.nii ../run4/Nulled_intemp.nii ../run5/Nulled_intemp.nii

3dMean -overwrite -prefix Av_BOLD_intemp.nii ../run1/BOLD_intemp.nii ../run2/BOLD_intemp.nii ../run3/BOLD_intemp.nii ../run4/BOLD_intemp.nii ../run5/BOLD_intemp.nii

3dMean -overwrite -prefix Av_moco_nulled.nii ../run1/moco_nulled.nii ../run2/moco_nulled.nii ../run3/moco_nulled.nii ../run4/moco_nulled.nii ../run5/moco_nulled.nii

3dMean -overwrite -prefix Av_moco_notnulled.nii ../run1/moco_notnulled.nii ../run2/moco_notnulled.nii ../run3/moco_notnulled.nii ../run4/moco_notnulled.nii ../run5/moco_notnulled.nii

#mv Av_BOLD_intemp.nii BOLD_intemp.nii
#mv Av_Nulled_intemp.nii Nulled_intemp.nii

LN_BOCO -Nulled Av_Nulled_intemp.nii -BOLD Av_BOLD_intemp.nii -output Av

FSLOUTPUTTYPE=NIFTI
fslmaths $1 -mul 2000 $1 -odt short

echo "I am correcting for the proper TR in the header"
3drefit -TR 1.5 Av_BOLD_intemp.nii
3drefit -TR 1.5 Av_VASO_LN.nii

echo "calculating Mean and tSNR maps"
3dTstat -mean -prefix mean_nulled.nii Av_moco_nulled.nii -overwrite
3dTstat -mean -prefix mean_notnulled.nii Av_moco_notnulled.nii -overwrite
3dTstat  -overwrite -mean  -prefix BOLD.Mean.nii Av_BOLD_intemp.nii'[1..$]'
3dTstat  -overwrite -cvarinv  -prefix BOLD.tSNR.nii Av_BOLD_intemp.nii'[1..$]'
3dTstat  -overwrite -mean  -prefix VASO.Mean.nii Av_VASO_LN.nii'[1..$]'
3dTstat  -overwrite -cvarinv -prefix VASO.tSNR.nii Av_VASO_LN.nii'[1..$]'

echo "calculating T1 in EPI space"
3dTcat -prefix combined.nii  Av_moco_nulled.nii Av_moco_notnulled.nii -overwrite
3dTstat -cvarinv -overwrite  -prefix T1w.nii combined.nii
rm -f combined.nii
#3dcalc -a mean_nulled.nii -b mean_notnulled.nii -expr 'abs(b-a)/(a+b)' -prefix T1w.nii -overwrite

echo "curtosis and skew"
#LN_SKEW -timeseries BOLD.nii
#LN_SKEW -timeseries VASO_LN.nii
