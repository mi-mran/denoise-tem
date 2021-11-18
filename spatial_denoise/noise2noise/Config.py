class Config:
    img_channel = 1
    max_epoch = 100
    crop_img_size = 256
    learning_rate = 0.001
    save_per_epoch = 10
    training_even = 'raw_dataset/even'
    training_odd = 'raw_dataset/odd'
    data_path_test ='data/test_set'
    data_path_checkpoint ='data/checkpoints_size256_epo'
    model_path_test='data/checkpoints_size256_100epo/denoise_epoch_100.pth'
    denoised_dir = 'data/denoised_results'
    cuda = "cuda:0"

