#!/usr/bin/env bash


## FMRI_TOPUP  - mean fmri images after motion correction and topup but before registration
# mean_fmriFWD.nii.gz                         FWD mean fmri in native space
# mean_fmriREV.nii.gz                         REV mean fmri in native space


## FMRI_TOPUP_REG - fmri images after topup and registration to t1
# coregistered_mean_fmriFWD.nii.gz            FWD mean fmri in native space
# coregistered_mean_fmriREV.nii.gz            REV mean fmri in native space
# coregistered_fmriFWD.nii.gz                 fmri time series
# mean_fmri_to_t1.mat

## WMSEG - White matter segmentation used with epi_reg
# wm.nii.gz                   White matter seg used for registration


## TOPUP - Input and output files of the topup process
# topup.nii.gz
# topup.topup_log
# topup_fieldcoef.nii.gz
# topup_fieldmap_hz.nii.gz
# topup_movpar.txt
# datain.txt


## FMRI_NO_TOPUP - images without topup for comparison
# mean_fmriFWD_no_topup.nii.gz
# mean_fmriREV_no_topup.nii.gz

## FMRI_REG  - images without topup, registered to t1
# coregistered_mean_fmriFWD_no_topup.nii.gz
# coregistered_mean_fmriREV_no_topup.nii.gz
# mean_fmriFWD_no_topup_to_t1.mat
# mean_fmriREV_no_topup_to_t1.mat


## FMRI_MNI - fmri images warped to MNI space
# wmeanfmri.nii.gz   Mean FWD fmri in MNI space
# wfmri.nii.gz       FWD fmri in MNI space
# swfmri.nii.gz      Smoothed FWD fmri in MNI space  (?)


## SPM_UNSMOOTHED
# spm_unsmoothed     SPM results unsmoothed

## SPM
# spm                SPM results smoothed

