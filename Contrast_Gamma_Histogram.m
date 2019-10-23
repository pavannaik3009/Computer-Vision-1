clc;
clear all;
close all;
im1 = double(imread('Image.bmp'));
figure(1)
imshow(im1,[])

[m,n] = size(im1);
mn = m*n;
%finding histogram of the image
histo = [zeros(1,256)];
pixval = im1;
for m1 = 1:1:m
    for n1 = 1:1:n
        histo(pixval(m1,n1)) = histo(pixval(m1,n1)) + 1;
    end
end
figure(2)
plot(histo)
max(histo);
axis([0 255 0 24429])
his1 = histo/(m*n);
figure(2)
plot(his1)

%To find CDF

cdf1(:,1) = histo(:,1);
for i = 2:1:256
    cdf1(1,i) = cdf1(:,i-1) + histo(:,i);
end

for n1 = 1:1:256
    if cdf1(1,n1)>(0.05*mn)
      hc = n1;
      break;
    end
end

for n1 = 256:-1:1
  if cdf1(1,n1)<0.95*mn
    hd = n1+1;
    break;
   end
end

%Computation of contrast stretching
ha = 0;
hb = 255;
for m1 = 1:1:m
    for n1 = 1:1:n
        imag(m1,n1) = int8(floor(((im1(m1,n1)-hc)/(hd-hc))*(hb-ha) + ha));
    end
end
figure(3)
imshow(imag)
title('Contrast Stretched Image')

%Gamma Correction
maxr = max(im1);
maxi = max(maxr)
c = floor(255/((double(maxi))^double(0.4)));
r = double(0.4);
for m1 = 1:m
    for n1 = 1:n
        gam(m1,n1) = floor((c*((im1(m1,n1)^r))));
    end
end
figure(4)
imshow(gam,[])
title('Gamma Correction Image')

%To perform histogram equalization
% Equation is floor((L-1)*CDF)
pdf1 = cdf1/(m*n);
x_ = floor(pdf1*255);

% To assign to a new histogram
for m1 = 1:1:m
    for n1 = 1:1:n
        newhis = x_(:,im1(m1,n1));
        hist_equ(m1,n1) = newhis;
    end
end
figure(5)
imshow(hist_equ,[])
title('Histogram Equalization Image')




