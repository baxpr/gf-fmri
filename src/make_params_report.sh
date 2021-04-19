#!/usr/bin/env bash

echo " "
echo " "
echo " "
echo $project $subject $session $scan
echo $thedate
echo Native T1 $(basename $mt1_niigz)
echo T1 segmentation $(basename $seg_niigz)
echo Atlas T1 $(basename $wmt1_niigz)
echo ICV $(basename $icv_niigz)
echo Atlas space warp $(basename $deffwd_niigz)
echo fMRI $(basename $fmriFWD_niigz)
echo RPE TOPUP fMRI $(basename $fmriREV_niigz)
echo Phase encoding direction $pedir
echo Output voxel size $vox_mm
echo "Using topup? $run_topup"
echo "Smoothing kernel fwhm $fwhm mm"
echo "High pass filter time $hpf sec"
echo Task $task
