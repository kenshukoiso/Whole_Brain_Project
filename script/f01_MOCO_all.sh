#!/bin/bash
# edited on Oct 19th

###########################################
###### parameters that are not used  ######
###########################################

echo How many cores would you like to use?
read ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS
tr=1
basevol=1000 # ANTs indexing

###########################################
####### preparig odd and even images ######
###########################################

###########################################
####### remove_NORDIC scancs ######
###########################################
echo How many noise scan?
read NOISESCAN
n_vols=`PrintHeader $1 | grep Dimens | cut -d ',' -f 4 | cut -d ']' -f 1`

#nthvol=$(($n_vols - 2)) # remove noise
3dcalc -a $1'[0..'`expr $n_vols - $NOISESCAN - 2`'(2)]' -expr 'a' -prefix notnulled.nii -overwrite
3dcalc -a $1'[1..'`expr $n_vols - $NOISESCAN - 1`'(2)]' -expr 'a' -prefix nulled.nii -overwrite

###########################################
####### generate moma once   ################
###########################################
# 3dAutomask -prefix moma.nii -peels 3 -dilate 2 notnulled.nii

###########################################
####### Do MOCO on nulled  ################
###########################################

n_vols=`PrintHeader nulled.nii | grep Dimens | cut -d ',' -f 4 | cut -d ']' -f 1`

echo "seperating $n_vols time steps to save RAM"
ImageMath 4 vol_.nii TimeSeriesDisassemble nulled.nii # vol_1000.nii, vol_1001.nii ...
rm -f vol_1000.nii vol_1001.nii
cp -f vol_1002.nii vol_1000.nii # removing steady state effects
cp -f vol_1003.nii vol_1001.nii

# 3dMean -prefix ../../n_reference.nii vol_1004.nii vol_1005.nii # there is no overwrite here, in case of multiple series
nthvol=$(($basevol + $n_vols - 1)) # Zero indexing
echo "doing the alignemt"
for i in $(eval echo "{$basevol..$nthvol}");
do
antsRegistration \
--dimensionality 3 \
--float 1 \
--collapse-output-transforms 1 \
--output [ vol_${i}_,vol_${i}_Warped.nii.gz,1] \
--interpolation BSpline[2] \
--use-histogram-matching 1 \
--winsorize-image-intensities [ 0.005,0.995 ] \
-x ../../referance_day1-/moma.nii \
--initial-moving-transform [ ../../referance_day1-/n_reference.nii,vol_${i}.nii,1 ] \
--transform Rigid[ 0.1 ] \
--metric MI[ ../../referance_day1-/n_reference.nii,vol_${i}.nii,1,32,Regular,0.25 ] \
--convergence [ 250x100,1e-6,10 ] \
--shrink-factors 2x1 \
--smoothing-sigmas 1x0vox \
--transform SyN[ 0.1,3,0 ] \
--metric CC[ ../../referance_day1-/n_reference.nii,vol_${i}.nii,1,2 ] \
--convergence [ 50x0,1e-6,10 ] \
--shrink-factors 2x1 \
--smoothing-sigmas 1x0vox
done
echo "reassembling the time points"
ImageMath 4 moco_nulled.nii TimeSeriesAssemble $tr 0 vol_*_Warped.nii.gz
rm -f vol_*.nii vol_*_0GenericAffine.mat vol_*_1Warp.nii.gz vol_*_1InverseWarp.nii.gz vol_*_InverseWarped.nii.gz vol_*_Warped.nii.gz

###########################################
####### Do MOCO on notnulled  ################
###########################################

n_vols=`PrintHeader notnulled.nii | grep Dimens | cut -d ',' -f 4 | cut -d ']' -f 1`

echo "seperating $n_vols time steps to save RAM"
ImageMath 4 vol_.nii TimeSeriesDisassemble notnulled.nii # vol_1000.nii, vol_1001.nii ...
rm -f vol_1000.nii vol_1001.nii
cp -f vol_1002.nii vol_1000.nii # removing steady state effects
cp -f vol_1003.nii vol_1001.nii

# 3dMean -prefix nn_reference.nii vol_1004.nii vol_1005.nii # there is no overwrite here, in case of multiple series
nthvol=$(($basevol + $n_vols - 1)) # Zero indexing
echo "doing the alignemt"
for i in $(eval echo "{$basevol..$nthvol}");
do
antsRegistration \
--dimensionality 3 \
--float 1 \
--collapse-output-transforms 1 \
--output [ vol_${i}_,vol_${i}_Warped.nii.gz,1] \
--interpolation BSpline[2] \
--use-histogram-matching 1 \
--winsorize-image-intensities [ 0.005,0.995 ] \
-x ../../referance_day1-/moma.nii \
--initial-moving-transform [ ../../referance_day1-/nn_reference.nii,vol_${i}.nii,1 ] \
--transform Rigid[ 0.1 ] \
--metric MI[ ../../referance_day1-/nn_reference.nii,vol_${i}.nii,1,32,Regular,0.25 ] \
--convergence [ 250x100,1e-6,10 ] \
--shrink-factors 2x1 \
--smoothing-sigmas 1x0vox \
--transform SyN[ 0.1,3,0 ] \
--metric CC[ ../../referance_day1-/nn_reference.nii,vol_${i}.nii,1,2 ] \
--convergence [ 50x0,1e-6,10 ] \
--shrink-factors 2x1 \
--smoothing-sigmas 1x0vox
done
echo "reassembling the time points"
ImageMath 4 moco_notnulled.nii TimeSeriesAssemble $tr 0 vol_*_Warped.nii.gz
rm -f vol_*.nii vol_*_0GenericAffine.mat vol_*_1Warp.nii.gz vol_*_1InverseWarp.nii.gz vol_*_InverseWarped.nii.gz vol_*_Warped.nii.gz

###################
#### clean up  ####
###################

rm -f nulled.nii notnulled.nii

## if you have multiple identical runs, you might want to average the nulled and not nulled series now.
