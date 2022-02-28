#!/bin/bash

ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=4
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS

for idx in 1 2 3 4 5 6 7 8 9; do


antsRegistration \
--dimensionality 3  \
--float 0  \
--verbose 1 \
--collapse-output-transforms 1  \
--output [registered${idx}_,registered${idx}_Warped.nii.gz,registered${idx}_InverseWarped.nii.gz]  \
--interpolation  BSpline[5]  \
--use-histogram-matching 0  \
--winsorize-image-intensities [0.005,0.995]  \
--initial-moving-transform [ref.nii,s$idx.nii,1]  \
--transform Rigid[0.1]  \
--metric MI[ref.nii,s$idx.nii,1,32,Regular,0.25]  \
--convergence [1000x500x250x100,1e-6,10]  \
--shrink-factors 12x8x4x2  \
--smoothing-sigmas 4x3x2x1vox  \
--transform Affine[0.1]  \
--metric MI[ref.nii,s$idx.nii,1,32,Regular,0.25]  \
--convergence [1000x500x250x100,1e-6,10]  \
--shrink-factors 12x8x4x2  \
--smoothing-sigmas 4x3x2x1vox  \
--transform SyN[0.1,3,0]  \
--metric MI[ref.nii,s$idx.nii,1,32,Regular,0.25]  \
--convergence [100x70x50x20,1e-6,10]  \
--shrink-factors 10x4x2x1  \
--smoothing-sigmas 5x2x1x0vox 

done



3dMean  -overwrite -prefix MEAN.nii \
                    ref.nii \
                    registered1_Warped.nii.gz \
                    registered2_Warped.nii.gz \
                    registered3_Warped.nii.gz \
                    registered4_Warped.nii.gz \
                    registered5_Warped.nii.gz \
                    registered6_Warped.nii.gz \
                    registered7_Warped.nii.gz \
                    registered8_Warped.nii.gz \
                    registered9_Warped.nii.gz
