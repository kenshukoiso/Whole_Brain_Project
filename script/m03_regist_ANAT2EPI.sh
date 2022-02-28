#!/bin/bash

#This script can be downloaded from here: https://github.com/layerfMRI/repository/blob/master/Alignement_scripts/align_0.5mm_MP2RAGE_2_EPI/executed_command.sh

ResampleImage 3 mask_orig.nii mask.nii 0.4x0.4x0.4 0 3['l'] 6

ResampleImage 3 mean_nulled.nii scaled_nulled.nii 0.4x0.4x0.4 0 3['l'] 6

ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=10
export ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS

antsRegistration \
--dimensionality 3  \
--float 0  \
--collapse-output-transforms 1  \
--interpolation BSpline[5] \
--output [registered1_mask_,registered1_Warped_mask.nii,registered1_InverseWarped_mask.nii]  \
--use-histogram-matching 0  \
--winsorize-image-intensities [0.005,0.995]  \
--initial-moving-transform initial_matrix.txt \
--transform Rigid[0.1]  \
--metric MI[EPI.nii,ANAT.nii,1,32,Regular,0.25]  \
--convergence [1000x500x250x100,1e-6,10]  \
--shrink-factors 12x8x4x2  \
--smoothing-sigmas 4x3x2x1vox  \
--transform Affine[0.1]  \
--metric MI[EPI.nii,ANAT.nii,1,32,Regular,0.25]  \
--convergence [1000x500x250x100,1e-6,10]  \
--shrink-factors 12x8x4x2  \
--transform SyN[0.1,3,0]  \
--metric CC[EPI.nii,ANAT.nii,1,4]  \
--convergence [50x50x70x50x20,1e-6,10]  \
--shrink-factors 10x6x4x2x1  \
--smoothing-sigmas 5x3x2x1x0vox


wait here
---------------------------

export FREESURFER_HOME=/Applications/freesurfer/7.2.0
source $FREESURFER_HOME/SetUpFreeSurfer.sh

pfad=$(pwd)
SUBJECTS_DIR=$pfad


#recon-all -s subject_name -i *.nii.gz  -all -parallel -openmp 4

recon-all -s S2 -i registered1_Warped.nii  -hires -openmp 4 -norandomness -expert ./expert.opts -brainstem-structures -hippocampal-subfields-T1

#Freesurfer -hires -openmp 4 -norandomness -expert ./expert.opts -brainstem-structures -hippocampal-subfields-T1
