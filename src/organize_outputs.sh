#!/usr/bin/env bash


## MEANFMRI  - mean fmri images after motion correction (and optionally topup) but before registration
# mean_fmriFWD.nii.gz                         FWD mean fmri in native space
# mean_fmriREV.nii.gz                         REV mean fmri in native space (topup only)


## MEANFMRI_REG - mean fmri images after motion correction, optionally topup, and registration to t1
# coregistered_mean_fmriFWD.nii.gz            FWD mean fmri in native space
# coregistered_mean_fmriREV.nii.gz            REV mean fmri in native space (topup only)
# mean_fmri_to_t1.mat

## FMRI_REG - fmri time series after motion correction, optionally topup, and registration to t1
# coregistered_fmriFWD.nii.gz                 fmri time series


## WMSEG - White matter segmentation of t1 used with epi_reg
# wm.nii.gz                   White matter seg used for registration


## TOPUP - Input and output files of the topup process
# topup.nii.gz
# topup.topup_log
# topup_fieldcoef.nii.gz
# topup_fieldmap_hz.nii.gz
# topup_movpar.txt
# datain.txt
#
# topup_skipped.txt


## MEANFMRI_REG_NO_TOPUP  - images without topup, registered to t1. For evaluation of topup  (topup only)
# coregistered_mean_fmriFWD_no_topup.nii.gz
# coregistered_mean_fmriREV_no_topup.nii.gz
# mean_fmriFWD_no_topup_to_t1.mat
# mean_fmriREV_no_topup_to_t1.mat


## PROBABLY DONT NEED THESE
## MEANFMRI_NO_TOPUP - images after motion correction but without topup or registration, for comparison
# mean_fmriFWD_no_topup.nii.gz
# mean_fmriREV_no_topup.nii.gz (topup only)




## MEANFMRI_MNI - mean fmri image after motion correction, topup(if), registration to t1, and warp to MNI space
# wmeanfmri.nii.gz   Mean FWD fmri in MNI space

## FMRI_MNI - fmri time series after motion correction, topup(if), registration to t1, and warp to MNI space
# wfmri.nii.gz       FWD fmri in MNI space

# SFMRI_MNI - smoothed fmri time series after motion correction, topup(if), registration to t1, and warp to MNI space
# swfmri.nii.gz      Smoothed FWD fmri in MNI space  (?)


## SPM_UNSMOOTHED
# spm_unsmoothed     SPM results unsmoothed

## SPM
# spm                SPM results smoothed

