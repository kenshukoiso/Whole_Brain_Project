#!/bin/bash

freeview -v \
mri/T1.mgz \
mri/wm.mgz \
mri/brainmask.mgz \
-f surf/lh.white:edgecolor=blue \
surf/lh.pial:edgecolor=red \
surf/rh.white:edgecolor=blue \
surf/rh.pial:edgecolor=red
