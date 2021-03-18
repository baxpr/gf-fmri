#!/usr/bin/env bash


mkdir -p OUTPUTS_141620_Oddball
singularity run --contain --cleanenv \
--home $(pwd)/INPUTS_141620 \
--bind INPUTS_141620:/INPUTS \
--bind OUTPUTS_141620_Oddball:/OUTPUTS \
test.simg \
--project GenFac_HWZ \
--subject 141620 \
--session 141620 \
--scan Oddball \
--mt1_niigz /INPUTS/mt1.nii.gz \
--fmriFWD_niigz /INPUTS/801_oddball1APA_FMRI_MB3_2_5mm_1300.nii.gz \
--fmriREV_niigz /INPUTS/401_rest2APP_FMRI_MB3_2_5mm_1300.nii.gz \
--seg_niigz /INPUTS/T1_seg.nii.gz \
--icv_niigz /INPUTS/p0t1.nii.gz \
--deffwd_niigz /INPUTS/y_t1.nii.gz \
--pedir +j \
--eprime_summary_csv /INPUTS/eprime_summary_OddballOld1.csv \
--vox_mm 1.5 \
--run_topup yes \
--fwhm 4 \
--hpf 300 \
--task Oddball \
--out_dir /OUTPUTS


mkdir -p OUTPUTS_141620_WM
singularity run --contain --cleanenv \
--home $(pwd)/INPUTS_141620 \
--bind INPUTS_141620:/INPUTS \
--bind OUTPUTS_141620_WM:/OUTPUTS \
test.simg \
--project GenFac_HWZ \
--subject 141620 \
--session 141620 \
--scan WM1 \
--mt1_niigz /INPUTS/mt1.nii.gz \
--fmriFWD_niigz /INPUTS/501_wm1APA_FMRI_MB3_2_5mm_1300.nii.gz \
--fmriREV_niigz /INPUTS/401_rest2APP_FMRI_MB3_2_5mm_1300.nii.gz \
--seg_niigz /INPUTS/T1_seg.nii.gz \
--icv_niigz /INPUTS/p0t1.nii.gz \
--deffwd_niigz /INPUTS/y_t1.nii.gz \
--pedir +j \
--eprime_summary_csv /INPUTS/eprime_summary_WM1.csv \
--vox_mm 1.5 \
--run_topup yes \
--fwhm 4 \
--hpf 300 \
--task WM \
--out_dir /OUTPUTS


mkdir -p OUTPUTS_141620_SPT
singularity run --contain --cleanenv \
--home $(pwd)/INPUTS_141620 \
--bind INPUTS_141620:/INPUTS \
--bind OUTPUTS_141620_SPT:/OUTPUTS \
test.simg \
--project GenFac_HWZ \
--subject 141620 \
--session 141620 \
--scan SPT \
--mt1_niigz /INPUTS/mt1.nii.gz \
--fmriFWD_niigz /INPUTS/1001_spt1APA_FMRI_MB3_2_5mm_1300.nii.gz \
--fmriREV_niigz /INPUTS/401_rest2APP_FMRI_MB3_2_5mm_1300.nii.gz \
--seg_niigz /INPUTS/T1_seg.nii.gz \
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


