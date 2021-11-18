import os
import imageio

N_FRAMES = 13

images = []

for i in range(N_FRAMES):
    name = f'bm3d_denoised/bm3d_TemP_ramp_01_CLC000_Hour_00_Minute_00_Second_08_10_Frame_{i}_{i + 19}.tif'
    images.append(name)

img_stack = []

for img in images:
    img_stack.append(imageio.imread(img))

imageio.mimsave('bm3d_denoised/bm3d_TemP_ramp_01_CLC000_Hour_00_Minute_00_Second_08_10_Frame_20ave.mp4', img_stack)
