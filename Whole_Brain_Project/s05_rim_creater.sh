#!/bin/bash

3dcalc -a ribbonmask_2000_rh.nii -b ribbonmask_2000_lh.nii -expr 'a + b ' -prefix fill.nii -overwrite
3dcalc -a lh.pial.epi_vol.nii -b rh.pial.epi_vol.nii  -expr 'a + b ' -prefix pial_vol.nii -overwrite
3dcalc -a lh.WM.epi_vol.nii   -b rh.WM.epi_vol.nii    -expr 'a + b ' -prefix WM_vol.nii   -overwrite


3dcalc -a fill.nii -b WM_vol.nii -c pial_vol.nii -prefix st_rim.nii -overwrite -expr 'step(c)+step(a)*3+step(b)*2-and(a,b)*3-and(a,c)*3'
##################
# input is binary_WMm, binary_CSF, binary_GM
# 3dcalc -a binary_CSF.nii -b a+i -c a-i -d a+j -e a-j -f a+k -g a-k -expr 'ispositive(a)*amongst(0,b,c,d,e,f,g)' -prefix pial.nii -overwrite
# 3dcalc -a binary_WMm.nii -b a+i -c a-i -d a+j -e a-j -f a+k -g a-k -expr 'ispositive(a)*amongst(0,b,c,d,e,f,g)' -prefix wm.nii -overwrite
# 3dcalc -a pial.nii -b wm.nii -c binary_GM.nii -prefix rim.nii -overwrite -expr 'a+2*c+3*b'
##################
3dcalc -a fill.nii -b WM_vol.nii -c pial_vol.nii -prefix rim_123.nii -overwrite -expr 'step(c)+step(a)*2+step(b)*3-and(a,b)*2-and(a,c)*2'


fslcpgeom EPI.nii dwscaled_columns10000.nii

LN2_BORDERIZE -input supra7_pial_2000_lh.nii -jumps 1 -output step1.nii
3dcalc -a supra7_pial_2000_lh.nii -b step1.nii -prefix step2.nii -expr 'abs(a-b)' -overwrite
3dmask_tool -input step2.nii -prefix step3.nii  -dilate_input 1 -overwrite -NN1
3dcalc -a step2.nii -b step3.nii -expr 'abs(a-b)' -overwrite -prefix step4.nii
3dcalc -a step4.nii -b supra7_pial_2000_lh.nii -expr b-a -overwrite -prefix lh.thin_pial.nii
# Nov 12th it didnot work well so do trick with suma, 3dSurf2Vol with "mode" option
