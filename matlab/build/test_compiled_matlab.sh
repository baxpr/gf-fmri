#!/usr/bin/env bash

../bin/run_spm12.sh /usr/local/MATLAB/MATLAB_Runtime/v97 \
function pipeline \
deffwd_niigz ../../INPUTS/y_t1.nii.gz \
meanfmri_niigz ../../INPUTS/OUTPUTS_SPT/coregistered_mean_fmriFWD.nii.gz \
fmri_niigz ../../INPUTS/OUTPUTS_SPT/coregistered_fmriFWD.nii.gz \
eprime_summary_csv ../../INPUTS/eprime_summary_SPT.csv \
motion_par ../../INPUTS/OUTPUTS_SPT/rfwd.par \
out_dir ../../OUTPUTS \
fwhm 4 \
hpf 300 \
task SPT
