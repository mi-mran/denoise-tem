function output=gab_median_fn(input)

    output=zeros(size(input),'like',input);
    mask=zeros(3);

    for r=1:size(input,1)
        for c=1:size(input,2)

            if r==1 && c==1
                mask(1,1)=input(1,1);
                mask(1,2:3)=input(1,1:2);
                mask(2:3,1)=input(1:2,1);
                mask(2:3,2:3)=input(1:2,1:2);
            elseif r==1 && c>1 && c<size(input,2)
                mask(1,:)=input(1,c-1:c+1);
				mask(2:3,:)=input(1:2,c-1:c+1);
            elseif r==1 && c==size(input,2)
                mask(1,3)=input(1,end);
                mask(1,1:2)=input(1,end-1:end);
                mask(2:3,3)=input(1:2,end);
                mask(1:2,1:2)=input(1:2,end-1:end);
            elseif r>1 && r<size(input,1) && c==size(input,2) 
                mask(:,3)=input(r-1:r+1,end);
                mask(:,1:2)=input(r-1:r+1,end-1:end);
            elseif r==size(input,1) && c==size(input,2)
                mask(3,3)=input(end,end);
                mask(3,1:2)=input(end,end-1:end);
                mask(1:2,3)=input(end-1:end,end);
                mask(1:2,1:2)=input(end-1:end,end-1:end);
            elseif r==size(input,1) && c>1 && c<size(input,2) 
                mask(3,:)=input(end,c-1:c+1);
                mask(1:2,:)=input(end-1:end,c-1:c+1);
            elseif r==size(input,1) && c==1
                mask(3,1)=input(end,1);
                mask(3,2:3)=input(end,1:2);
                mask(1:2,1)=input(end-1:end,1);
                mask(1:2,2:3)=input(end-1:end,1:2);
            elseif r>1 && r<size(input,1) && c==1 
                mask(:,1)=input(r-1:r+1,1);
                mask(:,2:3)=input(r-1:r+1,1:2);
            else
                mask=input(r-1:r+1,c-1:c+1);
            end

            maskv=sort(mask(:));

            output(r,c)=maskv(ceil(length(maskv)/2));

        end
    end
    
end