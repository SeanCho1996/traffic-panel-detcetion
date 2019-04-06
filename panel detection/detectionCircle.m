function  [circleElement,I] = detectionCircle(I_r,I,ii)

s = regionprops(I_r,'centroid');
centers = cat(1,s.Centroid);
s = regionprops(I_r,'MajorAxisLength');
majorAxisLength = cat(1,s.MajorAxisLength);
s = regionprops(I_r,'MinorAxisLength');
minorAxisLength = cat(1,s.MinorAxisLength);
diameters = mean([majorAxisLength minorAxisLength],2);
radii = diameters/2;
%%
% stats = regionprops('table',I_r,'Centroid',...
%     'MajorAxisLength','MinorAxisLength');
% centers = stats.Centroid;
% majorAxisLength = stats.MajorAxisLength;
% minorAxisLength = stats.MinorAxisLength;
% diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
% radii = diameters/2;

%  hold on
%  viscircles(centers,radii);
%  hold off

%% 
circleNb = 1;
if(size(diameters)==1 )
    circleCenters = centers;
    circleR = diameters/2;
    circleNb = 1;
else
    circleCenters=[];
    circleR = [];
    circleNb = 1;
    n = size(centers);
    for i = 1 : n
      if((abs(majorAxisLength(i)-minorAxisLength(i))<15)&&(minorAxisLength(i)>5)&& (majorAxisLength(i)>15))
          circleCenters(circleNb,:) = centers(i,:);
           circleR(circleNb) = diameters(i)/2;
           circleNb = circleNb + 1;
      end
    end
    circleNb = circleNb - 1;
end
%%
circler = circleR';
for i = 1:circleNb
    circleElement(i,1) = circler(i,1);  
    circleElement(i,2) = circleCenters(i,1);
    circleElement(i,3) = circleCenters(i,2);
end
circleElement = sortrows(circleElement,-1);

if(circleNb>20)   
    circleNb = 20;
    circleElement = circleElement(1:20,:);
end
%%
%figure,imshow(I_r)
%hold on,
%viscircles(circleCenters,circleR');
%hold off

I = double(I);
[height,width,x] = size(I);
bw = zeros(height,width);
for i = 1 : min(20,circleNb)
    r = circleElement(i,1);
    x = circleElement(i,2);
    y = circleElement(i,3);
    for n = 1 : size(I,1)
        for m = 1 : size(I,2)
            if(sqrt((n-round(y))^2+(m-round(x))^2)<=r)
                bw(n,m) = 1;
            end
        end
    end 
end
%imshow(bw);
for i = 1:3
    I(:,:,i) = I(:,:,i).*bw;
end
I = uint8(I);
%figure,imshow(I,[]),title(ii);
end