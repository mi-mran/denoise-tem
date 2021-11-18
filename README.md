# Analysis of TEM Data Using Machine Learning Methods
denoise-tem is a collection of methods used in denoising liquid transmission electron microscopy (LTEM) frames and video sequences. Machine learning and filter-based methods are tested and compared. Details of each method can be found within the respective folders.

## Objective
The objective of the project is to achieve denoised frames / video sequences whereby polymer vesicles can be distinguished from the background and the noise due to the low dosage of electrons during image acquisition. Ultimately, once it is qualitatively determined that the vesicles can be observed, changes in vesicle size / structure are expected to be observed while varying the surrounding temperature.

## Pre-processing
Dataset was originally acquired in the .dm4 format and was captured at 24fps over approximately 3 minutes. The DigitalMicrograph (DM) GUI from Gatan was used to visualise each frame of 4096x4096 pixels, but these raw images do not display any interpretable signal. This could be attributed to the extremely low electron dosage that was applied during acquisition. As such, they were pre-processed in the following steps:

1. Remove 0.1% of outliers from the pixel values at both ends of the pixel value distribution. This is done in order to minimise noise present per frame, without losing significant signal.
2. Consecutive frames were averaged to further reduce the frequency of noisy pixels, while maintaining the expected signal. A critical assumption made is that the motion of signal-carrying pixels between consecutive frames is slow enough for averaging such that the signal is not blurred in the resultant averaged frames. This assumption was made since the velocity of the liquid medium's motion across the imaging window during acquistion was unknown. Hence averaging over a larger set of images would have a greater effect of reducing the frequency of noisy pixels while increasing the probability of blurring the overall signal in the averaged image. Conversely, smaller average window sizes have a reversed effect. Different average window sizes were tested.
3. The resultant images are cropped to smaller dimensions since the corners of the images do not hold any useful information and runtimes of the methods can be reduced. To ensure a consistent region of interest (ROI) was maintained for model training and comparisons, DM scripts were used to save the consecutive averaged frames. These files are located in `utils/dm_scripts`.

## Outputs from Various Methods
A short summary of the method used is described in the respective folders along with the original code & paper links, and settings used in each method can be found in the respective folders.

## Post-processing
It was important to compare the results of consecutive averaged frames in a temporal fashion, since the motion of observed particles should be present in a continuous path and not in random paths. Various Python scripts were then used for comparison of the results by compiling the frames into short video sequences. These can be found in `utils/post_process`. 

## Folder Structure
1. spatial_denoise (methods used for denoising single frames)
2. utils (contains scripts for data / image manipulation / visualisation)

## About
This is my Final Year Project at the School of Materials Science and Engineering, Nanyang Technological University, supervised by Asst. Prof. Martial Duchamp. For more information or clarifications, please do contact me.

A work in progress.