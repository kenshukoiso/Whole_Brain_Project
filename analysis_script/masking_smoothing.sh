#!/bin/bash


#smoothing

LN_LAYER_SMOOTH -layer_file dwscaled_layers.nii -input Av_acrossdays_VASO_LN.nii -FWHM 0.8


#masking
3dcalc -a dwscaled_layers.nii -b smoothed_Av_acrossdays_VASO_LN.nii -expr 'equals(a,11)*b+equals(a,10)*b+equals(a,9)*b' -overwrite -prefix upper_VASO.nii
3dcalc -a dwscaled_layers.nii -b smoothed_Av_acrossdays_VASO_LN.nii -expr 'equals(a,8)*b+equals(a,7)*b+equals(a,6)*b+equals(a,5)*b' -overwrite -prefix middle_VASO.nii
3dcalc -a dwscaled_layers.nii -b smoothed_Av_acrossdays_VASO_LN.nii -expr 'equals(a,1)*b+equals(a,2)*b+equals(a,3)*b+equals(a,4)*b' -overwrite -prefix deeper_VASO.nii
