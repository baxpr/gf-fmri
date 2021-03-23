#!/usr/bin/env bash
#
# Main pipeline

echo Running ${0}

# Initialize defaults (will be changed later if passed as options)
export project=NO_PROJ
export subject=NO_SUBJ
export session=NO_SESS
export scan=NO_SCAN
export vox_mm=2
export run_topup=yes
export refimg_nii=avg152T1.nii
export src_dir=/opt/gf-fmri/src
export matlab_dir=/opt/gf-fmri/matlab/bin
export magick_dir=/usr/bin
export mcr_dir=/usr/local/MATLAB/MATLAB_Runtime/v97
export out_dir=/OUTPUTS

# Parse options
while [[ $# -gt 0 ]]
do
	key="$1"
	case $key in
		--project)
			export project="$2"; shift; shift ;;
		--subject)
			export subject="$2"; shift; shift ;;
		--session)
			export session="$2"; shift; shift ;;
		--scan)
			export scan="$2"; shift; shift ;;
		--mt1_niigz)
			export mt1_niigz="$2"; shift; shift ;;
		--wmt1_niigz)
			export wmt1_niigz="$2"; shift; shift ;;
		--fmriFWD_niigz)
			export fmriFWD_niigz="$2"; shift; shift ;;
		--fmriREV_niigz)
			export fmriREV_niigz="$2"; shift; shift ;;
		--seg_niigz)
			export seg_niigz="$2"; shift; shift ;;
		--icv_niigz)
			export icv_niigz="$2"; shift; shift ;;
		--deffwd_niigz)
			export deffwd_niigz="$2"; shift; shift ;;
		--pedir)
			export pedir="$2"; shift; shift ;;
		--eprime_summary_csv)
			export eprime_summary_csv="$2"; shift; shift ;;
		--vox_mm)
			export vox_mm="$2"; shift; shift ;;
		--run_topup)
			export run_topup="$2"; shift; shift ;;
		--fwhm)
			export fwhm="$2"; shift; shift ;;
		--hpf)
			export hpf="$2"; shift; shift ;;
		--task)
			export task="$2"; shift; shift ;;
		--out_dir)
			export out_dir="$2"; shift; shift ;;
		--src_dir)
			export src_dir="$2"; shift; shift ;;
		--matlab_dir)
			export matlab_dir="$2"; shift; shift ;;
		--mcr_dir)
			export mcr_dir="$2"; shift; shift ;;
		*)
			echo Unknown input "${1}"; shift ;;
	esac
done


# Date stamp
export thedate=$(date)


# Inputs report
echo "${project} ${subject} ${session} ${scan}"
echo ${thedate}
echo "pedir:    ${pedir}"
echo "fwhm:     ${fwhm}"
echo "hpf:      ${hpf}"
echo "out_dir:  ${out_dir}"


# FSL setup
. ${FSLDIR}/etc/fslconf/fsl.sh


# FSL preprocessing: motion correction, topup, coregistration to T1
fsl_processing.sh


# SPM processing: Warp to atlas space, smooth, first level stats, contrast images
# Also makes PDF and organizes outputs
"${matlab_dir}"/run_spm12.sh "${mcr_dir}" function pipeline \
	deffwd_niigz "${deffwd_niigz}" \
	wmt1_niigz "${wmt1_niigz}" \
	refimg_nii "${refimg_nii}" \
	meanfmri_niigz "${out_dir}"/coregistered_mean_fmriFWD.nii.gz \
	fmri_niigz "${out_dir}"/coregistered_fmriFWD.nii.gz \
	eprime_summary_csv "${eprime_summary_csv}" \
	motion_par "${out_dir}"/rfwd.par \
	out_dir "${out_dir}" \
	fwhm "${fwhm}" \
	hpf "${hpf}" \
	task "${task}"


# PDF and outputs org
make_pdf.sh
organize_outputs.sh

echo "Processing complete!"
