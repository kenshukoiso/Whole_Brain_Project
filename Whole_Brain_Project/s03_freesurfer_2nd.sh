#!/bin/bash

pfad=$(pwd)
SUBJECTS_DIR=$pfad
recon-all -autorecon2-wm -autorecon3 -subjid S8 &
