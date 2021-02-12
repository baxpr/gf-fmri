#!/usr/bin/env bash

# TODO
# Report correlation of topup fieldmap with actual fieldmap? fslcc but need to resample first

# Inputs
t1_niigz=../INPUTS/t1.nii.gz
fmriFWD_niigz=../INPUTS/fmri_FWD.nii.gz
fmriREV_niigz=../INPUTS/fmri_REV.nii.gz
#seg_niigz=../INPUTS/seg.nii.gz
pedir="+j"
vox_mm=2

# Copy files to working dir
wkdir=../OUTPUTS
cp "${t1_niigz}" "${wkdir}"/t1.nii.gz
cp "${fmriFWD_niigz}" "${wkdir}"/fwd.nii.gz
cp "${fmriREV_niigz}" "${wkdir}"/rev.nii.gz
#cp "${seg_niigz}" "${wkdir}"/seg.nii.gz

# Get in wkdir
cd "${wkdir}"

# Sanity check to make sure FWD isn't the short one
if [[ $(fslval fwd dim4) -lt $(fslval rev dim4) ]] ; then
	echo "fmri_FWD has fewer time points than fmri_REV"
	exit 1
fi

# Brain extract (eventually use slant?)
Echo Brain extraction
bet t1 t1brain -R -f 0.5 -m

# Gray matter mask from slant
#fslmaths seg -thr  3.5 -uthr  4.5 -bin -mul -1 -add 1 -mul seg tmp
#fslmaths tmp -thr 10.5 -uthr 11.5 -bin -mul -1 -add 1 -mul tmp tmp
#fslmaths tmp -thr 39.5 -uthr 41.5 -bin -mul -1 -add 1 -mul tmp tmp
#fslmaths tmp -thr 43.5 -uthr 45.5 -bin -mul -1 -add 1 -mul tmp tmp
#fslmaths tmp -thr 48.5 -uthr 52.5 -bin -mul -1 -add 1 -mul tmp tmp
#fslmaths tmp -bin gm
#rm tmp.nii.gz

# White matter mask from slant
#fslmaths seg -thr 39.5 -uthr 41.5 -bin tmp
#fslmaths seg -thr 43.5 -uthr 45.5 -add tmp -bin wm
#rm tmp.nii.gz

# Motion
Echo Motion correction
mcflirt -in fwd -meanvol -out rfwd
mcflirt -in rev -meanvol -out rrev

# Combine mean fMRIs to make topup input with two vols
fslmerge -t topup rfwd_mean_reg rrev_mean_reg

# Make topup phase dir info file
make_datain.sh "${pedir}"

# Run topup. Save the field map, but realize the sign and amplitude are not meaningful.
# Use b02b0_1 schedule to avoid issue with odd number of slices
Echo TOPUP
topup --imain=topup --datain=datain.txt --fout=topup_fieldmap_hz --config=b02b0_1.cnf

# Apply topup to fwd (this is the data we will actually analyze for fmri)
applytopup --imain=rfwd_mean_reg --inindex=1 --datain=datain.txt \
	--topup=topup --out=trfwd_mean_reg --method=jac

# Apply topup to rev - just for reference
applytopup --imain=rrev_mean_reg --inindex=2 --datain=datain.txt \
	--topup=topup --out=trrev_mean_reg --method=jac

# Register topup corrected mean fwd to T1
echo Coregistration
epi_reg --epi=trfwd_mean_reg --t1=t1 --t1brain=t1brain --out=ctrfwd_mean_reg
#epi_reg --epi=trfwd_mean_reg --t1=t1 --t1brain=t1brain --wmseg=wm --out=ctrfwd_mean_reg

# Use flirt to resample to the desired voxel size, overwriting epi_reg output image
flirt -applyisoxfm "${vox_mm}" -init ctrfwd_mean_reg.mat -in trfwd_mean_reg \
	-ref t1 -out ctrfwd_mean_reg

# Apply topup to actual time series
applytopup --imain=rfwd --inindex=1 --datain=datain.txt --topup=topup --out=trfwd --method=jac

# Apply coregistration to the topup-corrected time series
flirt -applyisoxfm "${vox_mm}" -init ctrfwd_mean_reg.mat -in trfwd -ref t1 -out ctrfwd

# Apply coreg to the mean topup corrected fmriREV - just for reference. Same matrix as for FWD
flirt -applyisoxfm "${vox_mm}" -init ctrfwd_mean_reg.mat -in trrev_mean_reg \
	-ref t1 -out ctrrev_mean_reg

# Register to T1 without topup - just for reference
epi_reg --epi=rfwd_mean_reg --t1=t1 --t1brain=t1brain --wmseg=ctrfwd_mean_reg_fast_wmseg --out=crfwd_mean_reg
#epi_reg --epi=rfwd_mean_reg --t1=t1 --t1brain=t1brain --wmseg=wm --out=crfwd_mean_reg

# Use flirt to resample to the desired voxel size, overwriting epi_reg output image
flirt -applyisoxfm "${vox_mm}" -init crfwd_mean_reg.mat -in rfwd_mean_reg \
	-ref t1 -out crfwd_mean_reg


# Give things more meaningful filenames
mv ctrfwd_mean_reg.nii.gz coregistered_mean_fmriFWD.nii.gz
mv ctrrev_mean_reg.nii.gz coregistered_mean_fmriREV.nii.gz
mv ctrfwd.nii.gz coregistered_fmriFWD.nii.gz
mv crfwd_mean_reg.nii.gz coregistered_mean_fmriFWD_no_topup.nii.gz

