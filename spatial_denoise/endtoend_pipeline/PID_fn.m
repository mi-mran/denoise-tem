function x1=PID_fn(y,sigma,N,filename)
    
    sigma2=sigma^2;
    
    r=15;
    sigma_s=7;
    gamma_r=988.5;
    gamma_s=2/9;
    alpha=1.533;
    lambda=log(alpha)*0.567;
    [dx, dy]=meshgrid(-r:r);
    r2=dx.^2+dy.^2;
    y=double(y);
    x=y;

    for i=1:N
        fprintf('starting %d iteration of PID_fn \n', i);
        xp=padarray(x,[r r],'symmetric');
        parfor p=1:numel(y), [Y, X]=ind2sub(size(y),p);

            %Spatial Domain
            d=xp(Y:Y+2*r,X:X+2*r)-x(p);
            T=sigma2*gamma_r*alpha^(-i);
            S=sigma_s^2*gamma_s*alpha^(i/2);
            k=exp(-d.^2/T).*exp(-r2/S);

            % Fourier Domain
            D=fft2(ifftshift(d.*k));
            V=sigma2*sum(k(:).^2);
            K=exp(-abs(D).^2/V);
            n=sum(sum(D.*K))/numel(K);

            x(p)=x(p)-lambda*real(n);
        end
%         if i==10 || i==20 || i==30 || i==40
%             i
%             imwrite(mat2gray(im2double(x)),[filename(1:end-4),'_PID_denoised',num2str(i),'.tif']);
%         end
    end
%     figure, imshow(x,[])

    x1=DDID_fn(x,y,sigma2,31,16,0.6,2.16);
%     figure, imshow(x1,[])

%     figure, imshowpair(x,x1,'montage')

    function xt=DDID_fn(x,y,sigma2,r,sigma_s,gamma_r,gamma_f)
        [dx, dy]=meshgrid(-r:r);
        h=exp(-(dx.^2+dy.^2)/(2*sigma_s^2));
        xp=padarray(x,[r r],'symmetric');
        yp=padarray(y,[r r],'symmetric');
        xt=zeros(size(x));

        parfor p=1:numel(x),[i, j]=ind2sub(size(x),p);

            %Spatial Domain - Bilateral Filter
            g=xp(i:i+2*r,j:j+2*r);
            y=yp(i:i+2*r,j:j+2*r);
            d=g-g(1+r,1+r);
            k=exp(-d.^2./(gamma_r*sigma2)).*h;
            gt=sum(sum(g.*k))/sum(k(:));
            st=sum(sum(y.*k))/sum(k(:));

            %Fourier Domain - Wavelet Shrinkage
            V=sigma2.*sum(k(:).^2);
            G=fft2(ifftshift(g-gt).*k);
            S=fft2(ifftshift(y-st).*k);
            K=1-exp(-abs(G).^2./(gamma_f*V));
            St=sum(sum(S.*K))/numel(K);

            xt(p)=st+real(St);
        end
    end

end