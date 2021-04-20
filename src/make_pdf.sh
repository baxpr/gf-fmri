#!/usr/bin/env bash

echo Making PDF

# FSL init
PATH=${FSLDIR}/bin:${PATH}
. ${FSLDIR}/etc/fslconf/fsl.sh

# Work in output directory
cd ${out_dir}

# Get some info from the matlab part
source matlab_envvars.sh

# Timestamp
thedate=$(date)

# EPI-to-T1 coregistration, native space, near WM COM
com=( $(fslstats wm -c) )
com[0]=$(echo ${com[0]} + 10 | bc)
fsleyes render -of coreg.png \
	--scene ortho --worldLoc ${com[@]} --displaySpace world --size 1800 600 --xzoom 1000 --yzoom 1000 --zzoom 1000 \
	--layout horizontal --hideCursor \
	coregistered_mean_fmriFWD --overlayType volume \
	gm --overlayType label --outline --outlineWidth 2 --lut harvard-oxford-subcortical
#	wm --overlayType label --outline --outlineWidth 2 --lut harvard-oxford-subcortical \


# EPI normalization, MNI space
fslmaths ${FSLDIR}/data/standard/tissuepriors/avg152T1_gray -thr 100 -bin gm_mni
fsleyes render -of mni.png \
	--scene ortho --worldLoc 10 -30 0 --displaySpace world --size 1800 600 --xzoom 600 --yzoom 600 --zzoom 600 \
	--layout horizontal --hideCursor \
	wmeanfmri --overlayType volume \
	gm_mni --overlayType label --outline --outlineWidth 2 --lut harvard-oxford-subcortical


# fMRI contrast image, slices
c=10
for slice in -35 -20 -5 10 25 40 55 70  ; do
	((c++))
	fsleyes render -of ax_${c}.png \
		--scene ortho --worldLoc 0 0 ${slice} --displaySpace world --size 600 600 --yzoom 1000 \
		--layout horizontal --hideCursor --hideLabels --hidex --hidey \
		wmt1 --overlayType volume \
		SPM/spmT_000${CONTRAST} --overlayType volume --displayRange 3 10 \
		--useNegativeCmap --cmap red-yellow --negativeCmap blue-lightblue
done


# README and methods info
cat <<- EOF > params.txt
	fMRI ANALYSIS PIPELINE gf-fmri for task $task, $thedate
	$project $subject $session $scan
	Main fMRI $(basename $fmriFWD_niigz), RPE TOPUP fMRI $(basename $fmriREV_niigz)
	Phase encoding direction is $pedir, topup is $run_topup
	Output voxel $vox_mm mm, smoothing kernel $fwhm mm fwhm, high pass filter $hpf sec
	
	
EOF
cat  params.txt /opt/gf-fmri/README.md > readme.txt
${magick_dir}/convert -size 2600x3365 xc:white -pointsize 32 -font Courier -fill black \
	-annotate +100+100 "@readme.txt" readme.png

# Combine
${magick_dir}/montage \
	-mode concatenate ax_*.png \
	-tile 3x -trim -quality 100 -background black -gravity center \
	-border 20 -bordercolor black page_ax.png

${magick_dir}/montage \
	-mode concatenate coreg.png mni.png \
	-tile 1x -trim -quality 100 -background black -gravity center \
	-border 20 -bordercolor black page_reg.png

info_string="$project $subject $session $scan"

${magick_dir}/convert -size 2600x3365 xc:white \
	-gravity center \( page_reg.png -resize 2400x \) -composite \
	-gravity North -pointsize 48 -annotate +0+100 \
	"Top: T1 gray matter outline on registered mean fMRI (native space)" \
	-gravity North -pointsize 48 -annotate +0+200 \
	"Bottom: Atlas gray matter outline on warped mean fMRI (atlas space)" \
	-gravity SouthEast -pointsize 48 -annotate +100+100 "${thedate}" \
	page_reg.png

${magick_dir}/convert -size 2600x3365 xc:white \
	-gravity center \( page_ax.png -resize 2400x \) -composite \
	-gravity North -pointsize 48 -annotate +0+100 \
	"$TASK fMRI results, $CONNAME" \
	-gravity SouthEast -pointsize 48 -annotate +100+100 "${thedate}" \
	-gravity NorthWest -pointsize 48 -annotate +100+200 "${info_string}" \
	page_ax.png

${magick_dir}/convert -size 2600x3365 xc:white \
	-gravity center \( first_level_design_001.png -resize 2400x \) -composite \
	-gravity SouthEast -pointsize 48 -annotate +100+100 "${thedate}" \
	first_level_design_001.png

${magick_dir}/convert readme.png page_reg.png page_ax.png first_level_design_001.png gf-fmri.pdf

