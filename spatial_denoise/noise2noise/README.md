# Noise2Noise: Learning Image Restoration without Clean Data
## Summary
Published in 2018, and is the basis of subsequent Noise2xxx implementations. Simply put, Noise2Noise aims to take noisy images as inputs and output clean images, without having access to clean reference images during training. This is unlike traditional image denoising methods, where there is access to clean reference images  It utilises a U-Net architecture with skip connections. It is assumed that for multiple noisy images with the same underlying signal, the mean (L2), median (L1) or mode (~L0) value (depending on the nature of dataset used) for each pixel of the signal would be approximately close to the true value of the pixel. Therefore the method does not require an explicit noise model and is applicable to our use case since there are no reference images. 

When applied to our extremely noisy dataset, the model does not significantly improve the quality of the images. This could possibly be due to: 1) Consecutive frames that were averaged did not have sufficient similarity in its underlying information, hence the pairs of images used in training were that of two different images 2) the size of the average window used on consecutive frames was too small. However if we increased the size of the window, the images would become increasingly blurred, which would not produce interpretable underlying information. Original paper [here](https://arxiv.org/abs/1803.04189). 

## Adaptation to EM Image Denoising
Though the original paper aims to denoise images, it focuses on photon-based and MRI images. However, [this paper](https://github.com/ZhenyuTan/Noise2Noise-Cryo-EM-image-denoising/blob/master/eecs504_report.pdf) is specifically for denoising cryo-EM images, hence more aligned towards the noise that would be typically encountered in TEM images. Therefore the aforementioned implementation is used as the base.

## Running Model
This model utilises Python 3 and PyTorch so please ensure that they are installed. Full package requirements can be found in `requirements.txt`. The model will run faster if a GPU is available.

1. Move the images intended for training into `raw_dataset/even` and `raw_dataset/odd`. Ensure that the name of both image pairs in either folder are the same. (eg. 0.png, 1.png, etc. in both folders) Make sure to check that the number of images in each folder is the same.
2. Move the images for testing into `data/test_set`. 
3. Set the intended parameters in `Config.py` as seen below. If you want to set a custom learning rate, change the `lr` setting in `train.py` instead. Most importantly, please set the correct paths for the training datasets and the test set.
```Python
# grayscale images
img_channel = 1
# set number of epochs
max_epoch = 100
# crop size parameter only used if test images are larger than training images. by default, training images are 256x256 so crop size is 256.
crop_img_size = 256
# static learning rate
learning_rate = 0.001
# frequency of saving model checkpoints
save_per_epoch = 10
training_even = 'PATH_TO_EVEN_IMAGES'
training_odd = 'PATH_TO_ODD_IMAGES'
data_path_test ='PATH_TO_TEST_SET_IMAGES'
# folder to save model checkpoints. PLEASE CHANGE AFTER EACH RUN. CHECKPOINTS WILL BE OVERWRITTEN IF THE SAME FOLDER NAME IS USED.
data_path_checkpoint ='/content/drive/MyDrive/FYP/model_22052021/data/checkpoints_size256_100epo'
# model checkpoint to be used for testing. generally use the last checkpoint from the folder
model_path_test='/content/drive/MyDrive/FYP/model_22052021/data/checkpoints_size256_100epo/denoise_epoch_100.pth'
denoised_dir = 'PATH_TO_DENOISED_IMAGES'
# if more than one gpu exists, specify which to use
cuda = "cuda:0"
```
4. Run `train.py` and the trained model will be saved to the path previously defined in `Config.py`. When running subsequent training sessions, it is important to rename `model_path_test` to avoid overwriting previously saved model checkpoints.
5. Run `test.py` to use the model file `model_path_test` in `Config.py`. The denoised results will be saved in `data/denoised_results`.



Code adapted from [here](https://github.com/ZhenyuTan/Noise2Noise-Cryo-EM-image-denoising/tree/master/noise2noise_model_for_Cryo_crop640).