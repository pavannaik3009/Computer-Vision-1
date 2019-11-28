clc;
clear all;
close all;

im = imread('bottle.bmp');
figure(1)
imshow(im);
title('Input Image');
histo = zeros(1,256);

for i = 1 : 600
    for j = 1 : 800
        pixel_value = im(i,j);
        histo(pixel_value + 1) = histo (pixel_value + 1) + 1;        
    end
end


xaxish = [0:1:255];

figure(2)
plot(xaxish,histo);
title('Histogram plot');
xlabel('Intensity value');
ylabel('No. of Pixels');


sum1 = sum(im);
sum2 = sum(sum1);
sum2 = sum2/(600*800);
im1 = zeros(600,800);

%Taking two thresholds as there is one very large peak with the required
%data

for m1 = 1:1:600
    for n1 = 1:1:800
        if im(m1,n1)<110
            im1(m1,n1) = 1;
        elseif im1(m1,n1)>162
            im1(m1,n1) = 1;
        else
            im1(m1,n1) = 0;
        end
    end
end

figure(3)
imshow(im1);
title('Thresholded Image');
bb = im1;
cc = im1;
%%%To remove holes, we perform dilation.
se = [1 1 1; 1 1 1; 1 1 1]; % Filter for dilation

im1 = bb;
for a = 1:3
g11 = zeros(600,800);
c = conv2(im1,se,'same');
for i = 1:600
    for j = 1:800
        if c(i,j)>=1
            g11(i,j) = 1;
        else
            g11(i,j) = 0;
        end
    end
end
im1 = g11;
end
figure(4)
imshow(g11)
title('Applying Dilation operator to fill the holes');
g1 = g11;

%%%Performing Disatance Transform
DF = zeros(600,800);
for m1 = 2:600
    for n1 = 2:800
        if g11(m1,n1)>0
            DF(m1,n1) = min([(g11(m1,n1-1)+1) (g11(m1-1,n1)+1)]);
            g11(m1,n1) = DF(m1,n1);
        end
    end
end

DB = zeros(600,800);
for m1 = 599:-1:1
    for n1 = 799:-1:1
        if DF(m1,n1)>0
            DB(m1,n1) = min([DF(m1,n1) (DF(m1+1,n1)+1) (DF(m1,n1+1)+1)]);
            DF(m1,n1) =  DB(m1,n1);
        end
    end
end
% To find maximum pixel value
maxval = max(max(DB));
%To find number of times pixel value repeats
a1 = 0;
for m1 = 1:600
    for n1 = 1:800
        if DB(m1,n1) == maxval
            a1 = a1+1;
        end
    end
end
maxval
a1
% count = a1
%Mapping to full dynmaic range
X7 = (DB-min(DB(:)))/(max(DB(:))-min(DB(:)))*255;
X7 = uint8(X7);
figure(6)
imshow(X7);
title('Mapped values of distance transform to the full dynamic range');


%%%%To find area, which is nothing but total number of pixels with a value
%%%%greater than 0.

area = 0;
for m1 = 1:600
    for n1 = 1:800
        if g1(m1,n1) >0
            area = area+1;
        end
    end
end
area = ['Area  = ' , num2str(area)];
disp(area)
sum(g1(:)) %if image is biary


%%%%%%%%%%%%To find centroid coordinates

total = 0;
xaxis = 0;
yaxis = 0;
for i = 1 : 600
    for j = 1 : 800
        if g1(i,j) ~= 0
            total = total + 1;
            xaxis = xaxis + i;
            yaxis = yaxis + j;
        end
    end
end
x_cent = xaxis/total;
y_cent = yaxis/total;

centorid = ['X-Centroid ' , num2str(x_cent) '   Y_Centroid ' , num2str(y_cent)];
disp(centorid);


%%%%%Perimeter
ref = g1;
im1 = g1;
for a = 1:1
g11 = zeros(600,800);
c = conv2(im1,se,'same');
for i = 1:600
    for j = 1:800
        if c(i,j)>=1
            g11(i,j) = 1;
        else
            g11(i,j) = 0;
        end
    end
end
im1 = g11;
end
p = abs(g11-ref);
figure(7)
imshow(p)
title('Perimeter of the Object');
t = 0;
for i = 1:600
    for j =1:800
        if p(i,j) >0
            t = t+1;
        end
    end
end
t1 = ['Perimeter is ' , num2str(t)];
disp(t1);

% %%%To calculate perimeter of the area which is white
% peri = 0;
% for m1 = 2:600-1
%     for n1 = 2:800-1
%         if g1(m1,n1) == 1
%             if (g1(m1-1,n1))*(g1(m1,n1-1))*(g1(m1+1,n1))*(g1(m1,n1+1)) == 0
%            
%             peri = peri+1;
%             end
%         end
%     end
% end
% peri
%%%Edge detection using sobel
% sh = [-1 0 1; -2 0 2; -1 0 1];
% sv = [-1 -2 -1; 0 0 0; 1 2 1];
% g1 = (g1-min(g1(:)))/(max(g1(:))-min(g1(:)))*255;
% 
% gx = zeros(600,800);
% for m1 = 2:600-2
%     for n1 = 2:800-2
%         cx = [g1(m1-1,n1-1)*sh(1) g1(m1-1,n1)*sh(2) g1(m1-1,n1+1)*sh(3) g1(m1,n1-1)*sh(4) g1(m1,n1)*sh(5) g1(m1,n1+1)*sh(6) g1(m1+1,n1-1)*sh(7) g1(m1+1,n1)*sh(8) g1(m1+1,n1+1)*sh(9)];
%         gx(m1,n1) = sum(cx);
%     end
% end
% 
% gy = zeros(600,800);
% for m1 = 2:600-1
%     for n1 = 2:800-1
%         cy = [g1(m1-1,n1-1)*sv(1) g1(m1-1,n1)*sv(2) g1(m1-1,n1+1)*sv(3) g1(m1,n1-1)*sv(4) g1(m1,n1)*sv(5) g1(m1,n1+1)*sv(6) g1(m1+1,n1-1)*sv(7) g1(m1+1,n1)*sv(8) g1(m1+1,n1+1)*sv(9)];
%         gy(m1,n1) = sum(cy);
%     end
% end
% G2 = (gx.^2)+(gy.^2);
% G = sqrt(G2);
% 
% peri = 0;
% for m1 = 2:600-1
%     for n1 = 2:800-1
%         if G(m1,n1)>0
%             if (G(m1-1,n1))*(G(m1,n1-1))*(G(m1+1,n1))*(G(m1,n1+1)) == 0
%            
%             peri = peri+1;
%             end
%         end
%     end
% end
% BW = edge(g1);
% edgperi = 0;
% for m1 = 2:599
%     for n1 = 2:599
%         if BW(m1,n1)>0
%             if (BW(m1-1,n1))*(BW(m1,n1-1))*(BW(m1+1,n1))*(BW(m1,n1+1)) == 0
%                 edgperi = edgperi+1;
%             end
%         end
%     end
% end

%%%%%%%%%%%%To find centroid coordinates

% a = (1:800);
% col = repmat(a,600,1);
% b = (1:600)';
% row = repmat(b,1,800);
% r = row(:).*DB(:);
% c = col(:).*DB(:);
% rans = sum(r)/(600*800);
% cans = sum(c)/(600*800);
% cenm=[round(rans)  round(cans)] % cenm = [x-coordinate  y-coordinate]
