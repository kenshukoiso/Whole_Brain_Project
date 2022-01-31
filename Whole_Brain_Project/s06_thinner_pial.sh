#!/bin/bash

### testing with left hemi ###
# 3dSurf2Vol -spec std_BOTH.ld2000.lh.orient.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -surf_B std_lh.ld2000.lh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr 0.07 -f_pn_fr -0.05 -prefix ribbonmask_2000_lh.nii -overwrite
#
3dSurf2Vol -spec std_BOTH.ld2000.lh.orient.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -surf_B std_lh.ld2000.lh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr 1.05 -f_pn_fr 0.1 -prefix ribbonmask_2000_lh_min_1p05_0p1.nii -overwrite
# 3dSurf2Vol -spec std_BOTH.ld2000.lh.orient.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -surf_B std_lh.ld2000.lh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr 1.0 -f_pn_fr 0.05 -prefix supra1_pial_2000_lh.nii -overwrite
# 3dSurf2Vol -spec std_BOTH.ld2000.lh.orient.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -surf_B std_lh.ld2000.lh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr 0.95 -f_pn_fr 0.0 -prefix supra2_pial_2000_lh.nii -overwrite
#
# 3dSurf2Vol -spec std_BOTH.ld2000.lh.orient.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -surf_B std_lh.ld2000.lh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr 1.0 -f_pn_fr 0.1 -prefix supra3_pial_2000_lh.nii -overwrite
# 3dSurf2Vol -spec std_BOTH.ld2000.lh.orient.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -surf_B std_lh.ld2000.lh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr 0.95 -f_pn_fr 0.05 -prefix supra4_pial_2000_lh.nii -overwrite
# 3dcalc -a ribbonmask_2000_lh_min_1p05_0p1.nii -b supra4_pial_2000_lh.nii -expr 'a*b' -prefix supra5_pial_2000_lh.nii
3dSurf2Vol -spec std_BOTH.ld2000.lh.orient.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -surf_B std_lh.ld2000.lh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr 0.90 -f_pn_fr 0.0 -prefix supra6_pial_2000_lh.nii -overwrite
3dcalc -a ribbonmask_2000_lh_min_1p05_0p1.nii -b supra6_pial_2000_lh.nii -expr 'a*b' -prefix supra7_pial_2000_lh.nii
# 3dcalc -a ribbonmask_2000_lh_min_1p05_0p1.nii -b supra6_pial_2000_lh.nii -expr 'step(a-b)' -prefix supra8_pial_2000_lh.nii

#generate GM
3dSurf2Vol -spec std_BOTH.ld2000.lh.orient.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -surf_B std_lh.ld2000.lh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr 0.0 -f_pn_fr 0.0 -prefix GM_lh.nii -overwrite
#remove pial by subtracting 7 supra7_pial_2000_lh to gave GM without kissing gyri

#generate WM
# 3dSurf2Vol -spec std_BOTH.ld2000.lh.orient.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -surf_B std_lh.ld2000.lh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr -2.0 -f_pn_fr 0.0 -prefix support_WM_2000_lh.nii -overwrite
3dSurf2Vol -spec std_BOTH.ld2000.lh.orient.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -surf_B std_lh.ld2000.lh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr -1.0 -f_pn_fr 0.0 -prefix WM_lh.nii -overwrite
# 3dSurf2Vol -spec std_BOTH.ld2000.lh.orient.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -surf_B std_lh.ld2000.lh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr -1.5 -f_pn_fr 0.0 -prefix WM_lh_1p5.nii -overwrite


### right hemi ###
3dSurf2Vol -spec std_BOTH.ld2000.rh.orient.spec -surf_A std_rh.ld2000.rh.smoothwm.obl.gii -surf_B std_rh.ld2000.rh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr 1.05 -f_pn_fr 0.1 -prefix supra_pial_2000_rh_min_1p05_0p1.nii -overwrite
3dSurf2Vol -spec std_BOTH.ld2000.rh.orient.spec -surf_A std_rh.ld2000.rh.smoothwm.obl.gii -surf_B std_rh.ld2000.rh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr 0.90 -f_pn_fr 0.0 -prefix supra6_pial_2000_rh.nii -overwrite
3dcalc -a supra_pial_2000_rh_min_1p05_0p1.nii -b supra6_pial_2000_rh.nii -expr 'a*b' -prefix supra7_pial_2000_rh.nii

3dSurf2Vol -spec std_BOTH.ld2000.rh.orient.spec -surf_A std_rh.ld2000.rh.smoothwm.obl.gii -surf_B std_rh.ld2000.rh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr 0.0 -f_pn_fr 0.0 -prefix GM_rh.nii -overwrite
3dSurf2Vol -spec std_BOTH.ld2000.rh.orient.spec -surf_A std_rh.ld2000.rh.smoothwm.obl.gii -surf_B std_rh.ld2000.rh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr -1.0 -f_pn_fr 0.0 -prefix WM_rh.nii -overwrite


### comine them ###
3dcalc -a GM_rh.nii -b GM_lh.nii -expr 'a + b ' -prefix GM_vol.nii -overwrite
3dcalc -a supra7_pial_2000_rh.nii -b supra7_pial_2000_lh.nii  -expr 'a + b ' -prefix pial_vol.nii -overwrite
3dcalc -a WM_rh.nii   -b WM_lh.nii    -expr 'a + b ' -prefix WM_vol.nii   -overwrite

3dcalc -a WM_vol.nii -b GM_vol.nii -c pial_vol.nii -prefix rim012.nii -overwrite -expr 'step(a)*2-step(b)-step(c)'
