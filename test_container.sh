#!/usr/bin/env bash

mkdir -p OUTPUTS_141651_WM
singularity run --contain --cleanenv \
--home $(pwd)/INPUTS_141651 \
--bind INPUTS_141651:/INPUTS \
--bind OUTPUTS_141651_WM:/OUTPUTS \
--bind /tmp:/tmp \
gf-fmri_v1.3.4.simg \
--project GenFac_HWZ \
--subject 141651 \
--session 141651 \
--scan 501-WM1 \
--mt1_niigz /INPUTS/mt1.nii.gz \
--wmt1_niigz /INPUTS/wmt1.nii.gz \
--fmriFWD_niigz /INPUTS/501_wm1APA_FMRI_MB3_2_5mm_1300.nii.gz \
--fmriREV_niigz /INPUTS/401_rest2APP_FMRI_MB3_2_5mm_1300.nii.gz \
--seg_niigz /INPUTS/T1_seg.nii.gz \
--icv_niigz /INPUTS/p0t1.nii.gz \
--deffwd_niigz /INPUTS/y_t1.nii.gz \
--pedir +j \
--eprime_summary_csv /INPUTS/eprime_summary_WM1.csv \
--vox_mm 2 \
--run_topup yes \
--fwhm 4 \
--hpf 300 \
--task WM \
--out_dir /OUTPUTS
