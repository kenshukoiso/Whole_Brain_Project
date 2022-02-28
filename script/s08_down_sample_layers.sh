#!/bin/bash

#Grab scaled_EPI.nii and st_rim_layers_equidist.nii from SUMA folder

delta_x=$(3dinfo -di scaled_EPI.nii)
delta_y=$(3dinfo -dj scaled_EPI.nii)
delta_z=$(3dinfo -dk scaled_EPI.nii)

sdelta_x=$(echo "((sqrt($delta_x * $delta_x) * 2))"|bc -l)
sdelta_y=$(echo "((sqrt($delta_y * $delta_y) * 2))"|bc -l)
sdelta_z=$(echo "((sqrt($delta_z * $delta_z) * 2))"|bc -l)

echo "$sdelta_x"
echo "$sdelta_y"
echo "$sdelta_z"

3dresample -dxyz $sdelta_x $sdelta_y $sdelta_z -rmode Bk -overwrite -prefix dwscaled_EPI.nii -input scaled_EPI.nii

3dresample -dxyz $sdelta_x $sdelta_y $sdelta_z -rmode NN -overwrite -prefix dwscaled_layers.nii -input rim4LN_layers_equidist.nii

# this is the refernce in the space of the functional data
short_me.sh EPI.nii

fslcpgeom EPI.nii dwscaled_EPI.nii
fslcpgeom EPI.nii dwscaled_layers.nii
