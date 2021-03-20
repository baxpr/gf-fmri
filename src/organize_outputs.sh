#!/usr/bin/env bash
#
# Organize outputs of gf-fmri pipeline. Needs env variable OUTDIR set


# Determine whether topup was performed
if [ -f "${OUTDIR}"/topup.nii.gz ]; then
	topup=true
else
	topup=false
fi
if $topup; then echo Topup output found; fi

# Get to output directory
cd "${OUTDIR}"

# PDF
mkdir PDF
mv gf-edat.pdf PDF

## MEANFMRI  - mean fmri images after motion correction (and optionally topup) but before registration
# mean_fmriFWD.nii.gz                         FWD mean fmri in native space
# mean_fmriREV.nii.gz                         REV mean fmri in native space (topup only)
mkdir MEANFMRI
mv mean_fmriFWD.nii.gz mean_fmriREV.nii.gz MEANFMRI

## MEANFMRI_REG - mean fmri images after motion correction, optionally topup, and registration to t1
# coregistered_mean_fmriFWD.nii.gz            FWD mean fmri in native space
# coregistered_mean_fmriREV.nii.gz            REV mean fmri in native space (topup only)
# mean_fmri_to_t1.mat
mkdir MEANFMRI_REG
mv coregistered_mean_fmriFWD.nii.gz coregistered_mean_fmriREV.nii.gz mean_fmri_to_t1.mat MEANFMRI_REG

## FMRI_REG - fmri time series after motion correction, optionally topup, and registration to t1
# coregistered_fmriFWD.nii.gz                 fmri time series
mkdir FMRI_REG
mv coregistered_fmriFWD.nii.gz FMRI_REG

## WMSEG - White matter segmentation of t1 used with epi_reg
# wm.nii.gz                   White matter seg used for registration
mkdir WMSEG
mv wm.nii.gz WMSEG

## TOPUP - Input and output files of the topup process
# topup.nii.gz
# topup.topup_log
# topup_fieldcoef.nii.gz
# topup_fieldmap_hz.nii.gz
# topup_movpar.txt
# datain.txt
#
# topup_skipped.txt
mkdir TOPUP
if $topup; then
	mv topup.nii.gz topup.topup_log topup_* datain.txt TOPUP
else
	touch TOPUP/topup_skipped.txt
fi

## MEANFMRI_REG_NO_TOPUP  - images without topup, registered to t1. For evaluation of topup  (topup only)
# coregistered_mean_fmriFWD_no_topup.nii.gz
# coregistered_mean_fmriREV_no_topup.nii.gz
# mean_fmriFWD_no_topup_to_t1.mat
# mean_fmriREV_no_topup_to_t1.mat
mkdir MEANFMRI_REG_NO_TOPUP
if $topup; then
	mv coregistered_mean_fmriFWD_no_topup.nii.gz coregistered_mean_fmriREV_no_topup.nii.gz \
		mean_fmriFWD_no_topup_to_t1.mat mean_fmriREV_no_topup_to_t1.mat MEANFMRI_REG_NO_TOPUP
else
	touch MEANFMRI_REG_NO_TOPUP/topup_skipped.txt
fi

## PROBABLY DONT NEED THESE
## MEANFMRI_NO_TOPUP - images after motion correction but without topup or registration, for comparison
# mean_fmriFWD_no_topup.nii.gz
# mean_fmriREV_no_topup.nii.gz (topup only)


## MEANFMRI_MNI - mean fmri image after motion correction, topup(if), registration to t1, and warp to MNI space
# wmeanfmri.nii.gz   Mean FWD fmri in MNI space
mkdir MEANFMRI_MNI
mv wmeanfmri.nii.gz MEANFMRI_MNI

## FMRI_MNI - fmri time series after motion correction, topup(if), registration to t1, and warp to MNI space
# wfmri.nii.gz       FWD fmri in MNI space
mkdir FMRI_MNI
mv wfmri.nii.gz FMRI_MNI

# SFMRI_MNI - smoothed fmri time series after motion correction, topup(if), registration to t1, and warp to MNI space
# swfmri.nii.gz      Smoothed FWD fmri in MNI space  (?)
mkdir SFMRI_MNI
mv swfmri.nii.gz SFMRI_MNI

## SPM_UNSMOOTHED
# spm_unsmoothed     SPM results unsmoothed
mv spm_unsmoothed SPM_UNSMOOTHED

## SPM
# spm                SPM results smoothed
mv spm SPM

