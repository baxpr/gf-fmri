#!/usr/bin/env bash

singularity run --contain --cleanenv \
--home $(pwd)/INPUTS \
--bind INPUTS:/INPUTS \
--bind OUTPUTS:/OUTPUTS \
test.simg \
--project TESTPROJ \
--subject TESTSESS \
--session TESTSUBJ \
--scan TESTSCAN \
--mt1_niigz /INPUTS/mt1.nii.gz \
--fmriFWD_niigz /INPUTS/fmri_FWD.nii.gz \
--fmriREV_niigz /INPUTS/fmri_REV.nii.gz \
--seg_niigz /INPUTS/seg.nii.gz \
--icv_niigz /INPUTS/p0t1.nii.gz \
--deffwd_niigz /INPUTS/y_t1.nii.gz \
--pedir +j \
--eprime_summary_csv /INPUTS/eprime_summary_SPT.csv \
--vox_mm 1.5 \
--run_topup yes \
--fwhm 4 \
--hpf 300 \
--task SPT \
--out_dir /OUTPUTS
