function [I,K]=deblur_fn(B,Nd,niter,filename)

    %% Kernel estimation

    lambda=5;   % default value of lambda
    %ksize=32
    ksize=32;

    [rb,cb]=size(B);
    Bv=reshape(double(B),[rb*cb 1]);   % vector form of B 

    I=Nd;   % initialization of I
    [rI,cI]=size(I);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%% Matrix form of I %%%%%%%%%%%%%%%%%%%%%%%%%%%%

    Am=zeros([rI*cI ksize^2],'double');
    ks=floor((ksize-1)/2);
    kt=floor(ksize/2);

    for i=1:rI
        fprintf('deblur_fn, i: %d\n', i);
        for j=1:cI
            for p=-ks:kt
                for q=-ks:kt
                    if i+p>0 && j+q>0 && i+p<=rI && j+q<=cI
                        Am((i-1)*cI+j,q+ks+1+(p+ks)*ksize)=I(i+p,j+q);
                    else
                        Am((i-1)*cI+j,q+ks+1+(p+ks)*ksize)=0;
                    end
                end
            end
        end
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%% Tikhonov regularization method %%%%%%%%%%%%%%%%%%%%%

    K=zeros([ksize^2 1]);
    K(floor(ksize^2/2))=1;  % initialize the kernel in vector form as delta

    At=Am';
    AtA=At*Am;
    AtBv=At*Bv;
    lambda2=lambda^2;
    E=eye(ksize^2);

    for i=1:niter
        fprintf('starting %d iteration of deblur_fn \n', i);
        K=K+AtBv-(AtA+lambda2*E)*K;
        K=K/sum(K(:));
    end

    K=reshape(K,[ksize ksize]); % estaimated kernel
    K=K/sum(K(:));                 % normalize the estimaetd kernel
%     imwrite(mat2gray(K),'kernel.png');
%     figure, imshow(K,[])    % deconvolution kernel

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %% Deconvolution 

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Compute Ir %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    NdK=zeros(size(B),'double');
    
    NdK=fftconv2(Nd,K);
    % figure, imshowpair(B,NdK,'montage')
    disp(size(B));
    disp(size(NdK));
    dB=B-NdK+1;
    % dB=dB-min(min(dB));
    % dB=dB./max(dB(:));
    dIr=deconvglucy(Nd,dB,K,niter,0,'true');
    % figure, imshow(dI,[])

    Ir=Nd+dIr;
    Ir=(Ir-min(Ir(:)))./(max(Ir(:))-min(Ir(:)));

    % figure, imshowpair(Ir,dIr,'montage')
    % title('diff Ir dIr')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Compute Ig %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    NdK=zeros(size(B),'double');

    NdK=fftconv2(Nd,K);
    % dB=B-NdK+1;
    % dB=dB+min(min(dB));
    % dB=dB./max(max(dB));
    dIg=deconvglucy(Nd,dB,K,niter,0.2,'true');
    %dIg=deconvglucy(Nd,dB,K,niter,0.2,'true');
    % figure, imshow(dI,[])

    Ig=Nd+dIg;
    Ig=(Ig-min(Ig(:)))/(max(Ig(:))-min(Ig(:)));

    % figure, imshowpair(Ig,dIg,'montage')
    % title('diff Ig dIg')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%
%     close all
%     figure, imshowpair(Ir,Ig,'montage')

    Ibar=zeros(size(Ir),'double');

    Ibar=jbfilter2(Ir,Ig,5,[1.6,0.08]);
%     figure, imshow(Ibar,[])
%     title('Ibar')

    Id=Ir+Ibar;
%     figure, imshow(Id,[])
%     title('Id')

    I=Ig+Id;

end