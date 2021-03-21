#!/usr/bin/env bash

# FSL init
PATH=${FSLDIR}/bin:${PATH}
. ${FSLDIR}/etc/fslconf/fsl.sh

# Work in output directory
cd ${out_dir}


# Get some info from the matlab part
source matlab_envvars.sh

thedate=$(date)

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



# Combine
${magick_dir}/montage \
	-mode concatenate ax_*.png \
	-tile 3x -trim -quality 100 -background black -gravity center \
	-border 20 -bordercolor black page_ax.png

info_string="$project $subject $session $scan"
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

${magick_dir}/convert page_ax.png first_level_design_001.png gf-fmri.pdf

rm *.png
