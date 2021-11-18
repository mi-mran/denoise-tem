function [I_sharp_local,K_loc]=stride_fn(I_PID,I_Nd,stride,w)

    I_sharp_local=zeros(size(I_PID),'double');
		   
	kcnt=0;

	for r=1:stride:size(I_PID,1)-w
		for c=1:stride:size(I_PID,2)-w

			kcnt=kcnt+1;
						
			kidx=[kcnt,r,c];

			[I_sharp_local(r:r+w,c:c+w),K_loc(:,:,kcnt)]=deblur_local_fn(I_PID(r:r+w,c:c+w),mat2gray(I_Nd(r:r+w,c:c+w)),30,[],kidx);
%  			  if rem(kcnt,5000)==0 || kcnt==1
%  				  imwrite(mat2gray(K_loc(:,:,kcnt)),['Local',num2str(kcnt),'_kernel.tif']);
%  			  end

		end
	end
	
	%imwrite(mat2gray(I_sharp_local),'Sharp_loc.tif');

end