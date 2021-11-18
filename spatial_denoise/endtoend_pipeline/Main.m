clear all
close all
clc
	
sel_folder=pwd;								% identify current folder 
 
file_patt=fullfile(sel_folder,'*.tif'); 	% look for .tif files 
files=dir(file_patt);
 
num_files=length(files);                % number of .tif files 
disp(num_files);
stride=	2;	% select stride
w=26                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     ; %128			% select window size
  
parfor n=1:num_files
    N=double(uint16(imread(files(n).name))); % Load input noisy image
    disp(strcat(files(n).name(1:end-4)));

        Nd=gab_median_fn(N);
        %Nd=medfilt2(N, [med med]);
        imwrite(mat2gray(Nd), strcat(files(n).name(1:end-4),'_median.tif')); 

        I_PID=PID_fn(Nd,50,30,files(n).name);
        imwrite(mat2gray(I_PID),strcat(files(n).name(1:end-4),'_PID.tif'));
	    
        [I_sharp,K_glob]=deblur_fn(double(uint16(I_PID)),mat2gray(double(uint16(Nd))),30,files(n).name);
    
        %figure, imshowpair(I_PID,I_sharp,'montage')

        imwrite(mat2gray(I_sharp),strcat(files(n).name(1:end-4),'_sharp.tif'));
        imwrite(mat2gray(K_glob),[files(n).name(1:end-4),'_global_kernel.tif']);

        [I_sharp_local,K_loc]=stride_fn(I_PID,Nd,stride,w);

        %figure, imshowpair(I_sharp,I_sharp_local,'montage')
        imwrite(mat2gray(I_sharp_local),[files(n).name(1:end-4), '_Sharp_loc.tif']);

end