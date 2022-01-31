#!/bin/bash

export FREESURFER_HOME=/Applications/freesurfer/7.2.0
source $FREESURFER_HOME/SetUpFreeSurfer.sh

pfad=$(pwd)
SUBJECTS_DIR=$pfad

# recon-all -s S2 -i *.nii.gz  -all -parallel -openmp 4
#
# recon-all -s S3 -i registered1_Warped.nii -all -hires -openmp 4 -parallel -wsthresh 75 -norandomness -expert ./expert.opts &
#
# recon-all -s S4 -i registered1_Warped.nii -all -hires -openmp 4 -parallel -wsthresh 200 -norandomness -expert ./expert.opts &
#
# recon-all -s S5 -i registered1_Warped.nii -all -hires
#
# recon-all -s S6 -i ANAT_scallstripped.nii -all -hires -openmp 4 -parallel -wsthresh 75 -norandomness -expert ./expert.opts &
#
# recon-all -s S7 -i ANAT_LR.nii -all -hires -openmp 4 -parallel -wsthresh 75 -norandomness -expert ./expert.opts &

recon-all -s S8 -i S8_ref/ANAT.nii -all -hires -openmp 4 -parallel -wsthresh 75 -norandomness -expert ./expert.opts &


### vusualization ###
freeview -v \
mri/T1.mgz \
mri/wm.mgz \
mri/brainmask.mgz \
-f surf/lh.white:edgecolor=blue \
surf/lh.pial:edgecolor=red \
surf/rh.white:edgecolor=blue \
surf/rh.pial:edgecolor=red
