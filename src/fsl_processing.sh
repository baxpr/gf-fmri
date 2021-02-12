#!/usr/bin/env bash

# Inputs
t1_niigz=../INPUTS/t1.nii.gz
fmriAPA_niigz=../INPUTS/fmri_APA.nii.gz
fmriAPP_niigz=../INPUTS/fmri_APP.nii.gz

# Copy files to working dir
wkdir=../OUTPUTS
cp "${t1_niigz}" "${wkdir}"/t1.nii.gz
cp "${fmriAPA_niigz}" "${wkdir}"/apa.nii.gz
cp "${fmriAPP_niigz}" "${wkdir}"/app.nii.gz

# Get in wkdir
cd "${wkdir}"

# Brain extract (eventually use slant?)
bet t1 t1brain -R -f 0.5 -m

# Motion
mcflirt -in apa -meanvol -out rapa
mcflirt -in app -meanvol -out rapp

# Combine mean fMRIs to make topup input with two vols
fslmerge -t topup rapa_mean_reg rapp_mean_reg

# Assume AP / j phase encoding direction
cat > datain.txt <<HERE
0 1 0 1
0 -1 0 1
HERE

# Run topup. Save the field map, but realize the sign and amplitude are not meaningful.
# Use b02b0_1 schedule to avoid issue with odd number of slices
topup --imain=topup --datain=datain.txt --fout=topup_fieldmap_hz --config=b02b0_1.cnf

# Apply topup to APA (this is the one we will actually use)
applytopup --imain=rapa_mean_reg --inindex=1 --datain=datain.txt \
	--topup=topup --out=trapa_mean_reg --method=jac

# Apply topup to APP - just for reference
applytopup --imain=rapp_mean_reg --inindex=1 --datain=datain.txt \
	--topup=topup --out=trapp_mean_reg --method=jac

# Register to T1
epi_reg --epi=trapa_mean_reg --t1=t1 --t1brain=t1brain --out=ctrapa_mean_reg

# Register to T1 without topup - just for reference
epi_reg --epi=rapa_mean_reg --t1=t1 --t1brain=t1brain --wmseg=ctrapa_mean_reg_fast_wmseg \
	--out=crapa_mean_reg

# Apply topup to actual time series
applytopup --imain=rapa --inindex=1 --datain=datain.txt --topup=topup --out=trapa --method=jac

# Apply coregistration to the topup-corrected time series
flirt -applyisoxfm 2 -init ctrapa_mean_reg.mat -in trapa -ref ctrapa_mean_reg -out ctrapa

# Apply coreg to the mean topup corrected fmriAPP - just for reference. Same matrix as for APA
flirt -applyisoxfm 2 -init ctrapa_mean_reg.mat -in trapp_mean_reg -ref ctrapa_mean_reg \
	-out ctrapp_mean_reg

# Give things more meaningful filenames
mv ctrapa_mean_reg.nii.gz coregistered_mean_fmriAPA.nii.gz
mv ctrapp_mean_reg.nii.gz coregistered_mean_fmriAPP.nii.gz
mv ctrapa.nii.gz coregistered_fmriAPA.nii.gz
mv crapa_mean_reg.nii.gz coregistered_mean_fmriAPA_notopup.nii.gz

