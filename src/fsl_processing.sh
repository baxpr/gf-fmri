#!/usr/bin/env bash

# TODO
# Report correlation of topup fieldmap with actual fieldmap? fslcc but need to resample first
# switch from FAST to SLANT

# Inputs
t1_niigz=../INPUTS/t1.nii.gz
fmriFWD_niigz=../INPUTS/fmri_FWD.nii.gz
fmriREV_niigz=../INPUTS/fmri_REV.nii.gz
seg_niigz=../INPUTS/seg.nii.gz
pedir="+j"
vox_mm=1.5
run_topup=yes

# Copy files to working dir
wkdir=../OUTPUTS
cp "${t1_niigz}" "${wkdir}"/t1.nii.gz
cp "${fmriFWD_niigz}" "${wkdir}"/fwd.nii.gz
cp "${fmriREV_niigz}" "${wkdir}"/rev.nii.gz
cp "${seg_niigz}" "${wkdir}"/seg.nii.gz

# Get in wkdir
cd "${wkdir}"

# Sanity check to make sure FWD isn't the short one
if [[ $(fslval fwd dim4) -lt $(fslval rev dim4) ]] ; then
	echo "fmri_FWD has fewer time points than fmri_REV"
	exit 1
fi

# Gray matter mask from slant
fslmaths seg -thr  3.5 -uthr  4.5 -bin -mul -1 -add 1 -mul seg tmp
fslmaths tmp -thr 10.5 -uthr 11.5 -bin -mul -1 -add 1 -mul tmp tmp
fslmaths tmp -thr 39.5 -uthr 41.5 -bin -mul -1 -add 1 -mul tmp tmp
fslmaths tmp -thr 43.5 -uthr 45.5 -bin -mul -1 -add 1 -mul tmp tmp
fslmaths tmp -thr 48.5 -uthr 52.5 -bin -mul -1 -add 1 -mul tmp tmp
fslmaths tmp -bin gm
rm tmp.nii.gz

# White matter mask from slant
fslmaths seg -thr 39.5 -uthr 41.5 -bin tmp
fslmaths seg -thr 43.5 -uthr 45.5 -add tmp -bin wm
rm tmp.nii.gz

# Motion
Echo Motion correction
mcflirt -in fwd -meanvol -out rfwd
mcflirt -in rev -meanvol -out rrev

# Run topup. After this, the 'tr' prefix files always contain the data that will be further
# processed, but it will only have had topup applied if run_topup option is yes.
if [[ "${run_topup}" == "yes" ]] ; then
	Echo Running TOPUP
	run_topup.sh "${pedir}" rfwd_mean_reg rrev_mean_reg rfwd
else
	echo SKIPPING TOPUP
	cp rfwd_mean_reg.nii.gz trfwd_mean_reg.nii.gz
	cp rrev_mean_reg.nii.gz trrev_mean_reg.nii.gz
	cp rfwd.nii.gz trfwd.nii.gz
fi


# Register corrected mean fwd to T1
echo Coregistration
epi_reg --epi=trfwd_mean_reg --t1=t1 --t1brain=t1brain --wmseg=wm --out=ctrfwd_mean_reg

# Use flirt to resample to the desired voxel size, overwriting epi_reg output image
flirt -applyisoxfm "${vox_mm}" -init ctrfwd_mean_reg.mat -in trfwd_mean_reg \
	-ref t1 -out ctrfwd_mean_reg

# Apply coregistration to the corrected time series
flirt -applyisoxfm "${vox_mm}" -init ctrfwd_mean_reg.mat -in trfwd -ref t1 -out ctrfwd

# Apply coreg to the mean corrected fmriREV - just for reference. Same matrix as for FWD
flirt -applyisoxfm "${vox_mm}" -init ctrfwd_mean_reg.mat -in trrev_mean_reg \
	-ref t1 -out ctrrev_mean_reg

# Register to T1 without topup - just for reference. FWD and REV. Redundant if we
# skipped topup earlier but that's ok
epi_reg --epi=rfwd_mean_reg --t1=t1 --t1brain=t1brain --wmseg=wm --out=crfwd_mean_reg
epi_reg --epi=rrev_mean_reg --t1=t1 --t1brain=t1brain --wmseg=wm --out=crrev_mean_reg

# Use flirt to resample to the desired voxel size, overwriting epi_reg output image
flirt -applyisoxfm "${vox_mm}" -init crfwd_mean_reg.mat -in rfwd_mean_reg \
	-ref t1 -out crfwd_mean_reg
flirt -applyisoxfm "${vox_mm}" -init crrev_mean_reg.mat -in rrev_mean_reg \
	-ref t1 -out crrev_mean_reg


# Give things more meaningful filenames
mv trfwd_mean_reg.nii.gz mean_fmriFWD.nii.gz
mv trrev_mean_reg.nii.gz mean_fmriREV.nii.gz

mv ctrfwd_mean_reg.nii.gz coregistered_mean_fmriFWD.nii.gz
mv ctrrev_mean_reg.nii.gz coregistered_mean_fmriREV.nii.gz
mv ctrfwd.nii.gz coregistered_fmriFWD.nii.gz
mv ctrfwd_mean_reg.mat corrected_fmri_to_t1.mat

mv rfwd_mean_reg.nii.gz mean_fmriFWD_no_topup.nii.gz
mv rrev_mean_reg.nii.gz mean_fmriREV_no_topup.nii.gz
mv crfwd_mean_reg.nii.gz coregistered_mean_fmriFWD_no_topup.nii.gz
mv crrev_mean_reg.nii.gz coregistered_mean_fmriREV_no_topup.nii.gz
mv crfwd_mean_reg.mat  mean_fmriFWD_no_topup_to_t1.mat
mv crrev_mean_reg.mat  mean_fmriREV_no_topup_to_t1.mat



