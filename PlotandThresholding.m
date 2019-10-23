clc;
clear all;
close all;
%Displaying the image.
im1 = imread('Image.bmp');
figure(1)
imshow(im1)
title('Input Image');

%Histogram plot generation
[m,n] = size(im1);
histo = [zeros(1,256)];
pixval = im1;
for m1 = 1:1:m
    for n1 = 1:1:n
        histo(pixval(m1,n1)) = histo(pixval(m1,n1)) + 1;
    end
end
figure(2)
plot(histo)
title('Histogram plot');
max(histo);
axis([0 255 0 24429])

%To detrmine the valleys in the histogram and accordingly the
%threshold. If no two clear valleys are present
t1 = input('Enter First threshold');
t2 = input('Enter second threshold');
s = sum(im1)
total = sum(s)
mean1 = total/(m*n)
im = im1;

for m1 = 1:1:m
    for n1 = 1:1:n
        if im1(m1,n1)<t1
            im(m1,n1) = 0;
        elseif im1(m1,n1)>t2
            im(m1,n1) = 0;
        else
            im(m1,n1) = 255;
        end
    end
end

figure(2)
imshow(im)
title('Threshold Image');
