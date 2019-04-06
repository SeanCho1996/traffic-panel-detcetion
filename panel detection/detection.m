function [I1] = detection(I)

%% imprimer l'image
% figure,imshow(I),title('initial');
%% pre-traitement d'image
Ihsv = rgb2hsv(I); 
S = Ihsv(:,:,2); 
V = Ihsv(:,:,3); 
mS = mean(mean(S));
mV = mean(mean(V));
[a,b,c] = size(I);
(sum(sum(I)))/a/b;

if(mS<0.2)   
    Ihsv(:,:,2) =0.3/mS.*Ihsv(:,:,2); 
end
if(mV<0.4)
    Ihsv(:,:,3) =0.4/mV.* Ihsv(:,:,3); 
end
I1 = hsv2rgb(Ihsv); 
(sum(sum(I1)))/a/b *255;
%figure,imshow(I1),title('after pre-operate');

%% segmentation HSV
[height,width,c]=size(Ihsv);
for i=1:height
    for j=1:width
        h=Ihsv(i,j,1);
        s=Ihsv(i,j,2);
        v=Ihsv(i,j,3);
        if (((h>=0 && h<=0.12)||(h>=0.93 && h<=1)) && (s>0.1) && (v>0.1))
            continue;
        else
            I1(i,j,1) = 0;
            I1(i,j,2) = 0;
            I1(i,j,3) = 0;
        end
    end
end

%figure,imshow(I1),title('segment HSV');
%% segmentation RGB
[height,width,c] = size(I1); 
IR = double(I1(:,:,1));
IG = double(I1(:,:,2));
IB = double(I1(:,:,3));
I1 = rgb2gray(I1);
for i = 1:height
    for j = 1:width
        if (1.3*IR(i,j) - IG(i,j) - IB(i,j) < 0)
            I1(i,j) = 0;
        elseif (1.3*IR(i,j) - IG(i,j) - IB(i,j) > 255)
            I1(i,j) = 255;   
        else 
            I1(i,j) = 1.3*IR(i,j) - IG(i,j) - IB(i,j);
        end
    end
end

%figure,imshow(I1),title('segment HSV et RGB');
end