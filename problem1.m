clc;
clear all;
close all;

im = imread('Text.bmp');
figure(1)
imshow(im);
title('Input Image');
histo = (zeros(1,256));

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
sum2 = uint8(sum2);

%hist1 = max(histo)/sum2;
im1 = im;
for m1 = 1:1:600
    for n1 = 1:1:800
        if im1(m1,n1)<sum2
            im1(m1,n1) = 1;
       
        else
            im1(m1,n1) = 0;
        end
    end
end
% im1 = double(im1);
figure(3)
imshow(im1,[]);
title('Thresholded Image');

bb = im1;
cc = im1;
se = [1 1 1; 1 1 1; 1 1 1]; % Filter for erosion
%%% assuming the top left pixel to be at coordinate (0,0), then the center
%%% of s should be there. Since convolution of a 2 single elements reults
%%% in a single element, its the same as multiplying
im1 = bb;
for a = 1:5
g = zeros(600,800);
c = conv2(im1,se,'same');
for i = 1:600
    for j = 1:800
        if c(i,j)>=9
            g(i,j) = 1;
        else
            g(i,j) = 0;
        end
    end
end
im1 = g;
end
% g = double(g);
figure(4)
imshow(g);
title('Applying Erosion operator 5 times');

%%%For dilation

sd = [1 1 1; 1 1 1; 1 1 1];
im1 = g;
for a = 1:5
g1 = zeros(600,800);
c = conv2(im1,se,'same');
for i = 1:600
    for j = 1:800
        if c(i,j)>=1
            g1(i,j) = 1;
        else
            g1(i,j) = 0;
        end
    end
end
im1 = g1;
end
figure(5)
imshow(g1);
title('Applying Dilation operator 5 times on eroded image');

%Difference between eroded and dialated image
diff = abs(double(bb)-double(g1));
diff1 = (diff-min(diff(:)))/(max(diff(:))-min(diff(:)))*255;
diff1 = uint8(diff1);
figure(6)
imshow(diff1);
title('Absolute difference image between Q3 and Q5 image');

%Erosion 10 times
im1 = bb;
im1 = bb;
for a = 1:10
g = zeros(600,800);
c = conv2(im1,se,'same');
for i = 1:600
    for j = 1:800
        if c(i,j)>=9
            g(i,j) = 1;
        else
            g(i,j) = 0;
        end
    end
end
im1 = g;
end

g = double(g);

g10 = g;
figure(7)
imshow(g);
title('Applying Erosion operator 10 times');

%Dilation 10 times
sd = [1 1 1; 1 1 1; 1 1 1];
im1 = g;
for a = 1:5
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
figure(8)
imshow(g11);
title('Applying Dilation operator 10 times on eroded image');

%Finding absolute difference 
diff2 = abs(double(bb)-g11);
diff22 = (diff2-min(diff2(:)))/(max(diff2(:))-min(diff2(:)))*255;

diff22 = uint8(diff22);

figure(9)
imshow(diff22);
title('Absolute difference image between image in Q3 and Q9');
