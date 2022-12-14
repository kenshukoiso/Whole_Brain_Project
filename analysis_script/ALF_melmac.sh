#!/bin/bash
for day in {1..10}
do
for run in {1..6}
do
echo "starting ALF: Amlpitude from low frequancy Fluctuations day:${day}, run:${run}"

fslpspec "BOLD_day${day}_run${run}.nii" "fslFFT_BOLD_day${day}_run${run}.nii" #calc the spectral power density of an input 4D data set
3dTstat -mean -prefix "AFL_BOLD_day${day}_run${run}.nii" -overwrite "fslFFT_BOLD_day${day}_run${run}.nii" #calc mean of the spectral powers to acquire Fluctuation Amlpitude (FA)
3dcalc -a "AFL_BOLD_day${day}_run${run}.nii" -expr 'a/10000' -prefix "AFL_BOLD_day${day}_run${run}.nii" -overwrite #"normalize" the FA

### normalize
# 3dcalc -a "AFL_BOLD_day${day}_run${run}.nii" -expr 'a/max(a)*1000' -prefix "Normalized_AFL_BOLD_day${day}_run${run}.nii"

echo "done: I expect: ALF_melmac.sh Dataset_timeseries.nii"
done
done

3dMean -prefix FluctuationAmplitude.nii AFL_BOLD_day*_run*

### noise removal with g-factor map
3dcalc -a FluctuationAmplitude.nii -b EPIspace_gfmap.nii -expr 'a/b' -prefix gf-cleaned_FluctuationAmplitude.nii -overwrite

### mask and layer
3dcalc -a gf-cleaned_FluctuationAmplitude.nii -b moma.nii -expr 'a*b' -prefix masked_gf-cleaned_FluctuationAmplitude.nii -overwrite

### visualization
start_bias_field.sh masked_gf-cleaned_FluctuationAmplitude.nii

3dcalc -a bico_masked_gf-cleaned_FluctuationAmplitude.nii -prefix clipped.nii -expr 'min(a,1)'
LN_INTPRO -image clipped.nii -max -range 10 -output Max_dir3_10slices.nii -direction 3
