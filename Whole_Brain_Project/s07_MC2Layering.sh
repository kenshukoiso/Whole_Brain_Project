#!/bin/bash

###########
# trying to remover jaggeredness without probmels of kissing gyri.
# note that you can use this only ONCE
3dcalc -a rim012.nii -expr 'step(a)' -prefix brain.nii -overwrite -datum short
3dcalc -a rim012.nii -expr 'step(2-a)' -prefix negWM.nii -overwrite -datum short
3dmask_tool -input brain.nii -prefix smooth_brain.nii -dilate_input -1 1 -overwrite
3dmask_tool -input negWM.nii -prefix smooth_negWM.nii -dilate_input -1 1 -overwrite
3dcalc -overwrite -prefix smooth_rim012.nii -a smooth_brain.nii -b smooth_negWM.nii -c rim012.nii -expr 'step(c)*(a+step(1-b))'
###########

#rim012 -> rim4LN
3dcalc -a smooth_rim012.nii -expr 'equals(a,1)' -prefix rimGM.nii -overwrite
LN2_CHOLMO -layers rimGM.nii -inner -nr_layers 1 -layer_thickness 0.44
3dcalc -a smooth_rim012.nii -b rimGM_padded.nii -expr 'equals(a,0)*equals(b,1)' -prefix rim_pia.nii -overwrite -datum short
3dcalc -a smooth_rim012.nii -b rimGM_padded.nii -expr 'equals(a,2)*equals(b,1)' -prefix rim_WM.nii -overwrite -datum short
3dcalc -a smooth_rim012.nii -b rim_pia.nii -c rim_WM.nii  -expr 'equals(a,1)*3+b+c*2' -prefix rim4LN.nii -overwrite -datum short


#apply layersinfication
LN2_LAYERS -rim rim4LN.nii -nr_layers 11 -equal_bins -incl_borders
mv rim4LN_layerbins_equidist.nii layers.nii
