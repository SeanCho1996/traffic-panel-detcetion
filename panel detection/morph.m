function [I_r] = morph(I)
[height,width,c]=size(I);
for i= 1:height
    for j = 1:width
        if(I(i,j,1)<0.06)
            I(i,j,1)=0;
            I(i,j,2)=0;
            I(i,j,3)=0;
        else
            I(i,j,1)=1;
            I(i,j,2)=1;
            I(i,j,3)=1;
        end
    end
end
I_r = im2bw(I);

%figure,imshow(I_r),title('close open');
I_r = imfill(I_r,'holes');
%figure,imshow(I_r),title('imfill');
I_r = imopen(I_r,strel('disk',2));
%figure,imshow(I_r),title('open');

D = -bwdist(~I_r);
L=watershed(D);
I_r(L == 0) = 0;
%figure,imshow(I_r),title('watershed'); 

end