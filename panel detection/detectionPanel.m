function [content,centerx,centery] = detectionPanel(I,circleElement)
[circleNb,x] = size(circleElement);
reduce_30 = imread('reduce_30.bmp');
reduce_50 = imread('reduce_50.bmp');
alert = imread('alert.bmp');

[h,w,useless] = size(reduce_50);
reduce_30 = imresize(reduce_30,[h,w]);
alert = imresize(alert,[h,w]);
IR = double(reduce_30(:,:,1));
IG = double(reduce_30(:,:,2));
IB = double(reduce_30(:,:,3));
reduce_30_sim = zeros(h,w,3);
for i = 1:h
    for j = 1:w
        if ((IR(i,j) + IG(i,j) + IB(i,j))/3 < 45)
            reduce_30_sim(i,j,1) = 0;
            reduce_30_sim(i,j,2) = 0;
            reduce_30_sim(i,j,3) = 0;
        else
            reduce_30_sim(i,j,1) = 255;
            reduce_30_sim(i,j,2) = 255;
            reduce_30_sim(i,j,3) = 255;
        end
    end
end
IR = double(alert(:,:,1));
IG = double(alert(:,:,2));
IB = double(alert(:,:,3));
alert_sim = zeros(h,w,3);
for i = 1:h
    for j = 1:w
        if ((IR(i,j) + IG(i,j) + IB(i,j))/3 < 20)
            alert_sim(i,j,1) = 0;
            alert_sim(i,j,2) = 0;
            alert_sim(i,j,3) = 0;
        else
            alert_sim(i,j,1) = 255;
            alert_sim(i,j,2) = 255;
            alert_sim(i,j,3) = 255;
        end
    end
end

IR = double(reduce_50(:,:,1));
IG = double(reduce_50(:,:,2));
IB = double(reduce_50(:,:,3));
reduce_50_sim = zeros(h,w,3);
for i = 1:h
    for j = 1:w
        if ((IR(i,j) + IG(i,j) + IB(i,j))/3 < 60)
            reduce_50_sim(i,j,1) = 0;
            reduce_50_sim(i,j,2) = 0;
            reduce_50_sim(i,j,3) = 0;
        else
            reduce_50_sim(i,j,1) = 255;
            reduce_50_sim(i,j,2) = 255;
            reduce_50_sim(i,j,3) = 255;
        end
    end
end
reduce_30 = im2bw(reduce_30);
reduce_50 = im2bw(reduce_50);
alert = im2bw(alert);

% reduce_30 = im2bw(reduce_30_sim);
% reduce_50 = im2bw(reduce_50_sim);
% alert = im2bw(alert_sim);

pio1 = [];
pio2 = [];
pio3 = [];



[height,width,x] = size(I);
for i= 1:circleNb
    circleR = circleElement(i,1);
    centerx = circleElement(i,2);
    centery = circleElement(i,3);
    [height,width,x] = size(I);
    if(centery-circleR>=0 && centerx-circleR>=0 && centery+circleR<=height && centerx+circleR<=width)
        I1 = I(centery-circleR:centery+circleR,centerx-circleR:centerx+circleR,:);       
    end
    if(centerx+circleR>width)
        I1 = I(centery-circleR:centery+circleR,centerx-circleR:centerx,:);
    end
    if(centery+circleR>height)
        I1 = I(centery-circleR:centery,centerx-circleR:centerx+circleR,:);
    end
    if(centerx-circleR<0)
        I1 = I(centery-circleR:centery+circleR,centerx:centerx+circleR,:);
    end
    if(centery-circleR<0)
        I1 = I(centery:centery+circleR,centerx-circleR:centerx+circleR,:);
    end
    Ihsv = rgb2hsv(I1); 
    S = Ihsv(:,:,2); 
    V = Ihsv(:,:,3); 
    mS = mean(mean(S));
    mV = mean(mean(V));

    
    Ihsv(:,:,2) =0.3/mS.*Ihsv(:,:,2);
    Ihsv(:,:,3) =0.42/mV.* Ihsv(:,:,3); 
     
    I1 = hsv2rgb(Ihsv); 
    I1 = imresize(I1,[h,w]);
    for a = 1:h
        for b = 1:w
            if((I1(a,b,1)+I1(a,b,2)+I1(a,b,3))/3>0.45)
                I1(a,b,1) = 1;
                I1(a,b,2) = 1;
                I1(a,b,3) = 1;
            else
                I1(a,b,1) = 0;
                I1(a,b,2) = 0;
                I1(a,b,3) = 0;
            end
        end
    end

    
    I1 = im2bw(I1);

    sum1 = 0;
    sum2 = 0;
    sum3 = 0;    
    for a = 1:h
      for b = 1:w
          if(reduce_30(a,b) == I1(a,b) &&  I1(a,b)==1) 
              sum1 = sum1+1;
          else if(reduce_30(a,b) == I1(a,b) &&  I1(a,b)==0)
                 sum1 = sum1+0.5;
              end
          end
          if(reduce_50(a,b) == I1(a,b) &&  I1(a,b)==1) 
              sum2 = sum2+1;
          else if(reduce_50(a,b) == I1(a,b) &&  I1(a,b)==0)
                 sum2 = sum2+0.5;
              end
          end
          if(alert(a,b) == I1(a,b) &&  I1(a,b)==1) 
              sum3 = sum3+1;
          else if(alert(a,b) == I1(a,b) &&  I1(a,b)==0)
                 sum3 = sum3+0.5;
              end
          end
      end
    end
    sum1 = double(sum1);
    sum2 = double(sum2);
    sum3 = double(sum3);
    a = abs(sum1 / (h*w) - 1);
    b = abs(sum2 / (h*w) - 1); 
    c = abs(sum3 / (h*w) - 1);
    pio1(i,1) = a;
    pio1(i,2) = circleR;
    pio1(i,3) = centerx;
    pio1(i,4) = centery;
    pio2(i,1) = b;
    pio2(i,2) = circleR;
    pio2(i,3) = centerx;
    pio2(i,4) = centery;
    pio3(i,1) = c;
    pio3(i,2) = circleR;
    pio3(i,3) = centerx;
    pio3(i,4) = centery;
end 

pio1 = sortrows(pio1,1);
pio2 = sortrows(pio2,1);
pio3 = sortrows(pio3,1);

reduce_30 = im2bw(reduce_30_sim);
reduce_50 = im2bw(reduce_50_sim);
alert = im2bw(alert_sim);

pio = [pio1(1,:);pio2(1,:);pio3(1,:)];
minP = [];
for i = 1:3
    p = pio(i,:);
    circleR = p(2);
    centerx = p(3);
    centery = p(4);
    [height,width,x] = size(I);
    if(centery-circleR>=0 && centerx-circleR>=0 && centery+circleR<=height && centerx+circleR<=width)
        I1 = I(centery-circleR:centery+circleR,centerx-circleR:centerx+circleR,:);
    end
    Ihsv = rgb2hsv(I1);
    S = Ihsv(:,:,2);
    V = Ihsv(:,:,3);
    mS = mean(mean(S));
    mV = mean(mean(V));
    Ihsv(:,:,2) =0.3/mS.*Ihsv(:,:,2);
    Ihsv(:,:,3) =0.42/mV.* Ihsv(:,:,3);
    I1 = hsv2rgb(Ihsv);
    I1 = imresize(I1,[h,w]);
    IR = double(I1(:,:,1));
    IG = double(I1(:,:,2));
    IB = double(I1(:,:,3));
    I1 = rgb2gray(I1);
    for a = 1:h
        for b = 1:w
            if (1.3*IR(a,b) - IG(a,b) - IB(a,b) < 0 && (IR(a,b) + IG(a,b) + IB(a,b))/3 <=0.45)
                I1(a,b) = 0;
            elseif (1.3*IR(a,b) - IG(a,b) - IB(a,b) > 1 || (IR(a,b) + IG(a,b) + IB(a,b))/3 >0.67)
                I1(a,b) = 1;
            else
                I1(a,b) = 1;
            end
        end
    end
    I1 = im2bw(I1);
    sum1 = 0;
    sum2 = 0;
    sum3 = 0;    
    for a = 1:h
      for b = 1:w
          if(reduce_30(a,b) == I1(a,b) &&  I1(a,b)==1) 
              sum1 = sum1+1;
          else if(reduce_30(a,b) == I1(a,b) &&  I1(a,b)==0)
                 sum1 = sum1+0.5;
              end
          end
          if(reduce_50(a,b) == I1(a,b) &&  I1(a,b)==1) 
              sum2 = sum2+1;
          else if(reduce_50(a,b) == I1(a,b) &&  I1(a,b)==0)
                 sum2 = sum2+0.5;
              end
          end
          if(alert(a,b) == I1(a,b) &&  I1(a,b)==1) 
              sum3 = sum3+1;
          else if(alert(a,b) == I1(a,b) &&  I1(a,b)==0)
                 sum3 = sum3+0.5;
              end
          end
      end
    end
    sum1 = double(sum1);
    sum2 = double(sum2);
    sum3 = double(sum3);
    a = abs(sum1 / (h*w) - 1);
    b = abs(sum2 / (h*w) - 1); 
    c = abs(sum3 / (h*w) - 1);
    A = [a b c];
    [a,p] = min(A);
    minP(i,1) = a;
    minP(i,2) = p;
    minP(i,3) = i;
end
minP = sortrows(minP,1);
content = minP(1,2);
pio = pio(minP(1,3),:);
centerx = pio(1,3);
centery = pio(1,4);
r = pio(1,2);
I_out(:,:,1) = I(centery-r:centery+r,centerx-r:centerx+r,1);
I_out(:,:,2) = I(centery-r:centery+r,centerx-r:centerx+r,2);
I_out(:,:,3) = I(centery-r:centery+r,centerx-r:centerx+r,3);
imshow(I_out,[]);
% if(content==1) content = 'reduce\_30';
% elseif(content==2) content = 'reduce\_50';
% else content = 'alert';
% end
% figure,imshow(II),
% hold on
% h.Color = [0 1 1];
% rectangle('Position',[pio(1,3)-pio(1,2),pio(1,4)-pio(1,2),2*pio(1,2),2*pio(1,2)],'EdgeColor',[0 1 1],'LineWidth',2);
% h = text(pio(1,3)-pio(1,2)-5,pio(1,4)-pio(1,2)-5,content);
% h.Color = [0 1 0];
% hold off

       
end