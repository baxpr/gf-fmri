# FMRI task analysis for GF Oddball, SPT, WM

## Preprocessing

Required inputs are the fMRI time series to be analyzed (fmriFWD), and a short additional fMRI time series acquired with same parameters but opposite phase encoding direction (fmriREV). Motion correction is applied to each separately with MCFLIRT. TOPUP is used with the two mean images output by motion correction, and the TOPUP warp is then applied to the mean images and the fmriFWD motion-corrected time series.

