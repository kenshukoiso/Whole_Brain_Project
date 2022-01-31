#!/bin/bash

cd S8
@SUMA_Make_Spec_FS -sid S8 -NIFTI
cd SUMA

cp ../../S8_ref/EPI.nii ./
cp ../../S8_ref/warped_MP2RAGE.nii ./

echo "************* upscaling EPI.nii    ******************************"


delta_x=$(3dinfo -di EPI.nii)
delta_y=$(3dinfo -dj EPI.nii)
delta_z=$(3dinfo -dk EPI.nii)

sdelta_x=$(echo "((sqrt($delta_x * $delta_x) / 2))"|bc -l)
sdelta_y=$(echo "((sqrt($delta_y * $delta_y) / 2))"|bc -l)
sdelta_z=$(echo "((sqrt($delta_z * $delta_z) / 2))"|bc -l)

echo "$sdelta_x"
echo "$sdelta_y"
echo "$sdelta_z"

3dresample -dxyz $sdelta_x $sdelta_y $sdelta_z -rmode Bk -overwrite -prefix scaled_EPI.nii -input EPI.nii

#get dense mesh
MapIcosahedron -spec S8_lh.spec -ld 2000 -prefix std_lh.ld2000. -overwrite
MapIcosahedron -spec S8_rh.spec -ld 2000 -prefix std_rh.ld2000. -overwrite


#from here
#get obliquity matrix
3dWarp -card2oblique warped_MP2RAGE.nii -verb scaled_EPI.nii -overwrite > orinentfile.txt

echo  "dense mesh starting"

echo "************************ get surfaces in oblique orientation left"
ConvertSurface -xmat_1D orinentfile.txt -i std_lh.ld2000.lh.pial.gii -o std_lh.ld2000.lh.pial.obl.gii -overwrite
ConvertSurface -xmat_1D orinentfile.txt -i std_lh.ld2000.lh.smoothwm.gii -o std_lh.ld2000.lh.smoothwm.obl.gii -overwrite

#get spec for the new file
quickspec -tn gii std_lh.ld2000.lh.pial.obl.gii
mv quick.spec std_lh.ld2000.lh.pial.obl.spec
quickspec -tn gii std_lh.ld2000.lh.smoothwm.obl.gii
mv quick.spec std_lh.ld2000.lh.smoothwm.obl.spec
inspec -LRmerge std_lh.ld2000.lh.smoothwm.obl.spec  std_lh.ld2000.lh.pial.obl.spec -detail 2 -prefix std_BOTH.ld2000.lh.orient.spec -overwrite

echo  " **************************"
echo  " get binary mask of surface left"
echo  " **************************"
3dSurf2Vol -spec std_lh.ld2000.lh.pial.obl.spec -surf_A std_lh.ld2000.lh.pial.obl.gii -map_func mask -gridset scaled_EPI.nii -prefix lh.pial.epi_vol.nii -sv T1.nii -overwrite
3dSurf2Vol -spec std_lh.ld2000.lh.smoothwm.obl.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -map_func mask -gridset scaled_EPI.nii  -prefix lh.WM.epi_vol.nii -sv T1.nii -overwrite
3dSurf2Vol -spec std_BOTH.ld2000.lh.orient.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -surf_B std_lh.ld2000.lh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr 0.07 -f_pn_fr -0.05 -prefix ribbonmask_2000_lh.nii -overwrite

### Nov 12th
# # "mode"
# 3dSurf2Vol -spec std_lh.ld2000.lh.pial.obl.spec -surf_A std_lh.ld2000.lh.pial.obl.gii -map_func mode -gridset scaled_EPI.nii -prefix lh.pial.epi_vol_mode.nii -sv T1.nii -overwrite
# 3dSurf2Vol -spec std_lh.ld2000.lh.smoothwm.obl.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -map_func mode -gridset scaled_EPI.nii  -prefix lh.WM.epi_vol_mode.nii -sv T1.nii -overwrite
# 3dSurf2Vol -spec std_BOTH.ld2000.lh.orient.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -surf_B std_lh.ld2000.lh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mode -f_steps 40 -f_index points -f_p1_fr 0.07 -f_pn_fr -0.05 -prefix ribbonmask_2000_lh_mode.nii -overwrite
# # "min"
# 3dSurf2Vol -spec std_lh.ld2000.lh.pial.obl.spec -surf_A std_lh.ld2000.lh.pial.obl.gii -map_func min -gridset scaled_EPI.nii -prefix lh.pial.epi_vol_min.nii -sv T1.nii -overwrite
# 3dSurf2Vol -spec std_lh.ld2000.lh.smoothwm.obl.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -map_func min -gridset scaled_EPI.nii  -prefix lh.WM.epi_vol_min.nii -sv T1.nii -overwrite
# 3dSurf2Vol -spec std_BOTH.ld2000.lh.orient.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -surf_B std_lh.ld2000.lh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func min -f_steps 40 -f_index points -f_p1_fr 0.07 -f_pn_fr -0.05 -prefix ribbonmask_2000_lh_min.nii -overwrite
# #
# 3dSurf2Vol -spec std_lh.ld2000.lh.pial.obl.spec -surf_A std_lh.ld2000.lh.pial.obl.gii -map_func mask -gridset scaled_EPI.nii -f_p1_fr 0.2 -f_pn_fr 0.2 -prefix lh.pial.epi_vol_p102_pn02pos.nii -sv T1.nii -overwrite
# 3dSurf2Vol -spec std_lh.ld2000.lh.pial.obl.spec -surf_A std_lh.ld2000.lh.pial.obl.gii -map_func mask -gridset scaled_EPI.nii -f_p1_fr 2 -f_pn_fr 2 -prefix lh.pial.epi_vol_p12_pn2pos.nii -sv T1.nii -overwrite
# 3dSurf2Vol -spec std_lh.ld2000.lh.pial.obl.spec -surf_A std_lh.ld2000.lh.pial.obl.gii -map_func mask -gridset scaled_EPI.nii -f_p1_fr 10 -prefix lh.pial.epi_vol_p110_pos.nii -sv T1.nii -overwrite
# 3dSurf2Vol -spec std_lh.ld2000.lh.pial.obl.spec -surf_A std_lh.ld2000.lh.pial.obl.gii -map_func mask -gridset scaled_EPI.nii -f_pn_fr 10 -prefix lh.pial.epi_vol_pn10_pos.nii -sv T1.nii -overwrite
#
# 3dSurf2Vol -spec std_lh.ld2000.lh.pial.obl.spec -surf_A std_lh.ld2000.lh.pial.obl.gii -map_func mask -gridset scaled_EPI.nii -f_p1_fr 10 -f_pn_fr 10 -prefix lh.pial.epi_vol_p110_pn10pos.nii -sv T1.nii -overwrite
# 3dSurf2Vol -spec std_lh.ld2000.lh.pial.obl.spec -surf_A std_lh.ld2000.lh.pial.obl.gii -map_func mask -gridset scaled_EPI.nii -f_p1_fr -10 -prefix lh.pial.epi_vol_p110_neg.nii -sv T1.nii -overwrite
# 3dSurf2Vol -spec std_lh.ld2000.lh.pial.obl.spec -surf_A std_lh.ld2000.lh.pial.obl.gii -map_func mask -gridset scaled_EPI.nii -f_pn_fr -10 -prefix lh.pial.epi_vol_pn10_neg.nii -sv T1.nii -overwrite
# 3dSurf2Vol -spec std_lh.ld2000.lh.pial.obl.spec -surf_A std_lh.ld2000.lh.pial.obl.gii -map_func mask -gridset scaled_EPI.nii -f_p1_fr 10 -f_pn_fr -10 -prefix lh.pial.epi_vol_p110_pn10posneg.nii -sv T1.nii -overwrite
# 3dSurf2Vol -spec std_lh.ld2000.lh.pial.obl.spec -surf_A std_lh.ld2000.lh.pial.obl.gii -map_func mask -gridset scaled_EPI.nii -f_p1_fr -10 -f_pn_fr 10 -prefix lh.pial.epi_vol_p110_pn10negpos.nii -sv T1.nii -overwrite
#
# 3dSurf2Vol -spec std_lh.ld2000.lh.pial.obl.spec -surf_A std_lh.ld2000.lh.pial.obl.gii -map_func mask -gridset scaled_EPI.nii -f_p1_mm 1.0 -f_pn_mm 1.0 -prefix lh.pial.epi_vol_p11_pn1mm.nii -sv T1.nii -overwrite
# #
# 3dSurf2Vol -spec std_lh.ld2000.lh.pial.obl.spec -surf_A std_lh.ld2000.lh.pial.obl.gii -map_func mask -gridset scaled_EPI.nii -f_p1_mm 2.0 -f_pn_mm 2.0 -prefix lh.pial.epi_vol_p12_pn2mm.nii -sv T1.nii -overwrite
#
# 3dSurf2Vol -spec std_BOTH.ld2000.lh.orient.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -surf_B std_lh.ld2000.lh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func min -f_steps 40 -f_index points -f_p1_fr 0.07 -f_pn_fr -0.05 -prefix ribbonmask_2000_lh_min.nii -overwrite

# is fill should be bigger
#3dSurf2Vol -spec std_BOTH.ld2000.lh.orient.spec -surf_A std_lh.ld2000.lh.smoothwm.obl.gii -surf_B std_lh.ld2000.lh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr -0.05 -f_pn_fr 0.05 -prefix ribbonmask_2000_lh.nii -overwrite


echo  " **************************"
echo  " *******DONE WITH LEFT HEMISHPERE"
echo  " **************************"

echo "************************ get surfaces in oblique orientation left"
ConvertSurface -xmat_1D orinentfile.txt -i std_rh.ld2000.rh.pial.gii -o std_rh.ld2000.rh.pial.obl.gii -overwrite
ConvertSurface -xmat_1D orinentfile.txt -i std_rh.ld2000.rh.smoothwm.gii -o std_rh.ld2000.rh.smoothwm.obl.gii -overwrite

#get spec for the new file
quickspec -tn gii std_rh.ld2000.rh.pial.obl.gii
mv quick.spec std_rh.ld2000.rh.pial.obl.spec
quickspec -tn gii std_rh.ld2000.rh.smoothwm.obl.gii
mv quick.spec std_rh.ld2000.rh.smoothwm.obl.spec
inspec -LRmerge std_rh.ld2000.rh.smoothwm.obl.spec  std_rh.ld2000.rh.pial.obl.spec -detail 2 -prefix std_BOTH.ld2000.rh.orient.spec -overwrite

echo  " **************************"
echo  " get binary mask of surface right"
echo  " **************************"
3dSurf2Vol -spec std_rh.ld2000.rh.pial.obl.spec -surf_A std_rh.ld2000.rh.pial.obl.gii -map_func mask -gridset scaled_EPI.nii -prefix rh.pial.epi_vol.nii -sv T1.nii -overwrite
3dSurf2Vol -spec std_rh.ld2000.rh.smoothwm.obl.spec -surf_A std_rh.ld2000.rh.smoothwm.obl.gii -map_func mask -gridset scaled_EPI.nii  -prefix rh.WM.epi_vol.nii -sv T1.nii -overwrite
3dSurf2Vol -spec std_BOTH.ld2000.rh.orient.spec -surf_A std_rh.ld2000.rh.smoothwm.obl.gii -surf_B std_rh.ld2000.rh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mask -f_steps 40 -f_index points -f_p1_fr 0.07 -f_pn_fr -0.05 -prefix ribbonmask_2000_rh.nii -overwrite
### Nov 12th "mode"
# 3dSurf2Vol -spec std_rh.ld2000.rh.pial.obl.spec -surf_A std_rh.ld2000.rh.pial.obl.gii -map_func mode -gridset scaled_EPI.nii -prefix rh.pial.epi_vol_mode.nii -sv T1.nii -overwrite
# 3dSurf2Vol -spec std_rh.ld2000.rh.smoothwm.obl.spec -surf_A std_rh.ld2000.rh.smoothwm.obl.gii -map_func mode -gridset scaled_EPI.nii  -prefix rh.WM.epi_vol_mode.nii -sv T1.nii -overwrite
# 3dSurf2Vol -spec std_BOTH.ld2000.rh.orient.spec -surf_A std_rh.ld2000.rh.smoothwm.obl.gii -surf_B std_rh.ld2000.rh.pial.obl.gii -sv T1.nii -gridset scaled_EPI.nii  -map_func mode -f_steps 40 -f_index points -f_p1_fr 0.07 -f_pn_fr -0.05 -prefix ribbonmask_2000_rh_mode.nii -overwrite
###

#3dLocalstat -nbhd 'SPHERE(0.2)' -prefix filled_ribbonmask_2000 ribbonmask_2000+orig

3dcalc -a ribbonmask_2000_rh.nii -b ribbonmask_2000_lh.nii -expr 'a + b ' -prefix fill.nii -overwrite
3dcalc -a lh.pial.epi_vol.nii -b rh.pial.epi_vol.nii  -expr 'a + b ' -prefix pial_vol.nii -overwrite
3dcalc -a lh.WM.epi_vol.nii   -b rh.WM.epi_vol.nii    -expr 'a + b ' -prefix WM_vol.nii   -overwrite


3dcalc -a fill.nii -b WM_vol.nii -c pial_vol.nii -prefix st_rim.nii -overwrite -expr 'step(c)+step(b)*2+3*step(a)-and(a,b)*3-and(a,c)*3'

LN2_LAYERS -rim st_rim.nii -nr_layers 7 -incl_borders

#3dLocalstat -nbhd 'SPHERE(0.3)' -stat mean -overwrite -prefix filled_fill.nii fill.nii

###3dcalc -a pial_vol.nii -b WM_vol.nii -c fill.nii -expr 'step(a)+2*step(b)+3*step(c)-3*step(a*c)-3*step(b*c)' -prefix rim.nii -overwrite

echo "und tschuess"
