# End-to-end Image Analysis Pipeline for Liquid-phase Electron Microscopy
## Summary
The pipeline of the image involves progressively applying a median filter, patch normalisation, [Progressive Image Denoising](https://ieeexplore.ieee.org/document/6820766) (PID) and Local Extension Deblur (LED), based on [this](https://dl.acm.org/doi/10.1145/1276377.1276379). So far, this method has produced the most promising results as compared to other results, where the PID step contributed the greatest improvement in image interpretability. PID performs better denoising when as the number of iterations increases, but the improvements are no longer significant past 40 iterations. In addition, the LED step requires an estimate of the blurring function, comprising of the blurring due to the liquid thickness and the CTF of the microscope. Original paper [here](https://onlinelibrary.wiley.com/doi/full/10.1111/jmi.12889).

## Running Pipeline
In order to run the full pipeline procedure, please ensure that MATLAB is installed. The code has been modified to allow for parallel processing of input images, which requires the Parallel Computing Toolbox. However this can be disabled by changing the `parfor` to an ordinary `for` loop in `Main.m`. In addition, the Image Process Toolbox should be installed.

Ensure that the images to be tested are placed in this folder (or the same folder with all the MATLAB files). The default setup is used for .tif images, but can be adapted to other image extensions by changing it correspondingly on `Main.m`. Once ready, run `Main.m`. Do note that using larger images requires greater RAM usage and also requires exponentially longer runtimes. Hence if a local image area can be selected, it is better to run the pipeline on smaller images to initially visualise the results.

The results will be saved in the current folder, with the appropriate name extensions based on the output at different steps (ie. {IMAGENAME}_median, _PID, _global_kernel, _sharp and _sharp_local). The `_sharp_local` image is intended to be the final result from the pipeline.

## Testing of Different Parameters
Parameters of the various steps can be found in the respective code blocks.

### Median Filter
Different median filter sizes are tested, while the default patch normalisation is only applied for a 3x3 filter size.

Highlight / comment out the following lines based on the desired median kernel setting in `Main.m`. The example shows the usage of the default 3x3 kernel size with the patch normalisation while the commented portion is an 11x11 kernel size only.

```matlab
Nd=gab_median_fn(N);
%Nd=medfilt2(N, [11 11]);
```

### PID
The number of iterations can be changed as such in `Main.m`:

```matlab
I_PID=PID_fn(Nd,50,30,files(n).name);
```

where 30 iterations is currently set.

The stride and kernel size of this function can be changed as such in `deblur_fn.m`:

```matlab
lambda=5;
ksize=32;
```
where `lambda` and `ksize` represent the stride length and kernel size respectively.

### LED
Similarly, the stride and kernel size of the LED step can be changed as such in `Main.m`:

```matlab
stride=2;
w=26;
```

where `stride` and `w` represent the stride length and kernel size respectively. 

It may also be worth exploring the settings for the local deblurring function used in LED, found in `deblur_local_fn.m`:

```matlab
lambda=5;
ksize=32;
```

where `lambda` and `ksize` represent the stride length and kernel size respectively.

Code adapted from [here](https://github.com/GabrieleMarchello/LPEM-post-processing-pipeline).