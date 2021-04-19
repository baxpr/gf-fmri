# FMRI task analysis for GF Oddball, SPT, WM

## Preprocessing

Required inputs are the fMRI time series to be analyzed (fmriFWD), and a short additional fMRI 
time series acquired with same parameters but opposite phase encoding direction (fmriREV). Motion 
correction is applied to each separately with MCFLIRT. TOPUP is used with the two mean images 
output by motion correction, and the TOPUP warp is then applied to the mean images and the 
fmriFWD motion-corrected time series. The resulting fMRI are warped to MNI space using the 
supplied deformation, and first level statistical analysis is performed using SPM for the chosen 
task.

The pipeline is installed in the container at `/opt/gf-fmri`.

To build, note that the matlab binary must be created first. See `matlab/build/BUILD.md`. The 
actual matlab code here and in the container is for reference only, and is not used at runtime.

For an example run command, see `test_container.sh`.


## Inputs

*Resources from cat12 pipeline, e.g. cat12_ss2p0_v2*
     
    --mt1_niigz               BIAS_CORR     Native space bias-corrected T1
    --wmt1_niigz              BIAS_NORM     Atlas space bias-corrected T1
    --icv_niigz               ICV_NATIVE    Native space processed T1 masked to intracranial volume
    --deffwd_niigz            DEF_FWD       Forward deformation from native to atlas space

*Resources from Multi-Atlas/SLANT pipeline e.g. slant_gpu_v1*
    
    --seg_niigz               SEG           Segmented native space T1

*Functional MRI*
    
    --fmriFWD_niigz           Task fMRI run
    --fmriREV_niigz           Reverse phase encoded fMRI for topup (if topup used)
    --pedir                   Phase encoding direction, voxel axis: +i, -i, +j, -j, +k, or -k

*Stimulus/task information from gf-edat pipeline e.g. gf-edat-WM_v2*
    
    --eprime_summary_csv      SUMMARY_CSV   Table of conditions and stimulus timing

*Processing options*
    
    --vox_mm                  Voxel size for intermediate resampling of fMRI in native space
    --run_topup               'yes' or 'no'. See --fmriREV_niigz
    --fwhm                    Atlas space smoothing kernel in mm before first level stats
    --hpf                     Temporal high pass filter for fMRI time series in sec
    --task                    Task. 'Oddball', 'SPT', or 'WM'
    --refimg_nii              Sets output geometry. 'avg152T1.nii' (2mm) or 'TPM.nii' (1.5mm)
    --out_dir                 Output directory for results

*Info for PDF report title if run on XNAT*
    
    --project
    --subject
    --session
    --scan

*Extra options only needed for testing*
    
    --src_dir                 Location of pipeline shell scripts
    --matlab_dir              Location of pipeline matlab code
    --mcr_dir                 Location of Matlab Compiled Runtime


## Outputs

    PDF                       Processing report
    MEANFMRI                  Native space mean fMRI after motion correction/topup
    MEANFMRI_REG              Native space mean fMRI after mot corr/topup and registration to t1
    FMRI_REG                  Native space fMRI time series after mot corr/topup and registration
    MEANFMRI_MNI              Atlas space mean fMRI after mot corr/topup and registration
    FMRI_MNI                  Atlas space fMRI time series after mot corr/topup and registration
    SFMRI_MNI                 Smoothed atlas space fMRI
    MEANFMRI_REG_NO_TOPUP     Native space mean fMRIs without topup, for evaluation of topup
    TOPUP                     Topup-related files
    WMSEG                     White matter mask used with epi_reg
    SPM                       SPM first level stats results directory
    SPM_UNSMOOTHED            SPM results with no smoothing used
