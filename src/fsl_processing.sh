#!/usr/bin/env bash

# MCFLIRT motion correction. To mean image, and store mats
mcflirt -in fmri -meanvol -mats -o rfmri

# Brain extract using slant
fslmaths seg -bin -mul t1 t1brain
bet b0_e1 b0_e1_brain

# Convert Hz field map to rad/s
# https://www.jiscmail.ac.uk/cgi-bin/wa-jisc.exe?A2=ind1708&L=FSL&D=0&P=58332
fslmaths b0_e2 -mul 6.28 -mul 0.001 b0_e2_rads

# Gray matter mask
fslmaths seg -thr  3.5 -uthr  4.5 -bin -mul -1 -add 1 -mul seg tmp
fslmaths tmp -thr 10.5 -uthr 11.5 -bin -mul -1 -add 1 -mul tmp tmp
fslmaths tmp -thr 39.5 -uthr 41.5 -bin -mul -1 -add 1 -mul tmp tmp
fslmaths tmp -thr 43.5 -uthr 45.5 -bin -mul -1 -add 1 -mul tmp tmp
fslmaths tmp -thr 48.5 -uthr 52.5 -bin -mul -1 -add 1 -mul tmp tmp
fslmaths tmp -bin gm
rm tmp.nii.gz

# White matter mask
fslmaths seg -thr 39.5 -uthr 41.5 -bin tmp
fslmaths seg -thr 43.5 -uthr 45.5 -add tmp -bin wm
rm tmp.nii.gz


# Register EPI to T1
epi_reg --epi=rfmri_mean_reg --t1=t1 --t1brain=t1brain --wmseg=wm --out=crfmri_mean_reg


# EPI registration with fieldmap
es=0.000297832
epi_reg --epi=rfmri_mean_reg --t1=t1 --t1brain=t1brain --wmseg=wm --out=frfmri_mean_reg \
        --fmap=b0_e2_rads --fmapmag=b0_e1 --fmapmagbrain=b0_e1_brain --echospacing=$es --pedir=-y



# Files produced
#
#   rfmri.mat/MAT_????      Motion correction transform for each volume to mean fMRI
#   rfmri.nii.gz            Motion corrected/resampled
#   rfmri_mean_reg.nii.gz   Mean fMRI after motion correction
#
#   crfmri_mean_reg.nii.gz  Mean fMRI registered/resampled to T1
#   crfmri_mean_reg.mat     Transform from mean fMRI to T1
