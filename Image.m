clc;
clear all;
close all;
im = imread('Image.bmp');
imwrite(im,'im1.jpg');
im_gray = imread('im1.jpg');
figure()
imshow(im_gray);
title('Input Image');
[m,n] = size(im_gray);
ix = [-2 -1 0 1 2];
iy = ix';
Ix = conv2(im_gray,ix,'same');
Iy = conv2(im_gray,iy,'same');
Ix2 = Ix.^2;
Iy2 = Iy.^2;
Ixy = Ix.*Iy;
figure()
imshow(Ix)
title('Derivative applied in Horizontal Direction');
figure()
imshow(Iy)
title('Derivative applied in Vertical Direction');
ga = [exp(-2) exp(-1) 1 exp(-1) exp(-2)];
gau = (ga'*ga)/((2*pi));
ix2 = conv2(Ix2,gau,'same');
iy2 = conv2(Iy2,gau,'same');
ixy = conv2(Ixy,gau,'same');
k = 0.05;
Hmax = 0; 
for i = 1:m
for j = 1:n
harris(i,j) = (ix2(i,j)*iy2(i,j) - (ixy(i,j))^2) - k*(ix2(i,j) + iy2(i,j))^2;
if harris(i,j) > Hmax
Hmax = harris(i,j);
end;
end;
end;
a = sum(sum((harris)));
a = a/(m*n);
cnt = 0;
metric1 = zeros(m,n);
for i = 3:m-2
for j = 3:n-2
if harris(i,j) > 0.01*Hmax && harris(i,j) > harris(i-1,j-1) && harris(i,j) > harris(i-1,j) && harris(i,j) > harris(i-1,j+1) && harris(i,j) > harris(i,j-1) && harris(i,j) > harris(i,j+1) && harris(i,j) > harris(i+1,j-1) && harris(i,j) > harris(i+1,j) && harris(i,j) > harris(i+1,j+1) && harris(i,j) > harris(i-2,j-2) && harris(i,j) > harris(i-2,j-1) && harris(i,j) > harris(i-2,j) && harris(i,j) > harris(i-2,j+1) && harris(i,j) > harris(i-2,j+2) && harris(i,j) > harris(i+2,j-2) && harris(i,j) > harris(i+2,j-1) && harris(i,j) > harris(i+2,j) && harris(i,j) > harris(i+2,j+1) && harris(i,j) > harris(i+2,j+2) && harris(i,j) > harris(i-1,j-2)  && harris(i,j) > harris(i,j-2) && harris(i,j) > harris(i+1,j-2) && harris(i,j) > harris(i-1,j+2)  && harris(i,j) > harris(i,j+2) && harris(i,j) > harris(i+1,j+2)   
result(i,j) = 1;
metric1(i,j) = harris(i,j);

cnt = cnt+1;
end;
end;
end;
[pc, pr] = find(result == 1);
cnt ;
figure()
imshow(im_gray);
hold on;
plot(pr,pc,'r.');
title('Selected Features');
hold off;


%%%ADAptive NMS
q=1;
for i=1:size(metric1,1)
    for j=1:size(metric1,2)
        if(metric1(i,j)~=0)
        metric1_array(q)=metric1(i,j);
        x_cord(q)=i;
        y_cord(q)=j;
        q=q+1;
        end
        
    end
end
%Arranging in decending order.
[R,a]=sort(metric1_array,'descend');
        for i=1:size(a,2)
            x_cord_new(i)=x_cord(a(i));
            y_cord_new(i)=y_cord(a(i));    
        end
        
%we need to take each non zero pixel and find the pixel that is k% greater than the pixel under consideration with the least distance between them.        
k=25;
R_new=0;
for i=2:size(R,2)
    min_dist=200;     %we need to take the max value
    for j=i-1:-1:1
        if(((R(j)-R(i))>(k*R(i)/100)))
            dist=sqrt((x_cord_new(i)-x_cord_new(j))^2+((y_cord_new(i)-y_cord_new(j))^2));
            if (dist<min_dist)
                min_dist=dist;
                if(R_new==0)
                    R_new(1)=max(max(R));
                    radius(1)=m*n;
                    x_cord_sorted(1)=x_cord_new(1);
                    y_cord_sorted(1)=y_cord_new(1);
                end
                R_new(i)=R(j);
                radius(i)=min_dist;
                x_cord_sorted(i)=x_cord_new(i);
                y_cord_sorted(i)=y_cord_new(i);
            end
        end
    end                             
end

%now, we have the array sorted according to the raduis. we need to take top
%k values. Rest of the values will be 0. Convert it into matrix.
%top_n=5
top_n=150;
for i=top_n:size(R_new,2)
    R_new(i)=0;
end

final_mat_rot=zeros(m,n);
%{
for i=1:size(x_cord_sorted,2)
    final_mat(x_cord_sorted(i),y_cord_sorted(i))=R_new(i);
end
%}
for i=1:size(x_cord_new,2)
    final_mat_rot(x_cord_new(i),y_cord_new(i))=R_new(i);
   if R_new(i) == 0
       x_cord_new(i) = 0;
       y_cord_new(i) = 0;
   end
end
metric = harris;
g1 = uint8(final_mat_rot);
g1 = imrotate(g1,45);
figure
imshow(uint8(imrotate(final_mat_rot,45)));
hold on;
plot(x_cord_new,y_cord_new, 'rx');
hold off



figure;imshow(im);
hold on;
plot(y_cord_new, x_cord_new, 'rx');
title('ANMS');
hold off;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%Rotated
im_gray1 = imrotate(im_gray,45);
figure()
imshow(im_gray1);
title('Rotated Input Image');
[m,n] = size(im_gray1);
% ix = [-1 0 0 0 1;-1 0 0 0 1;-1 0 0 0 1];
% iy = [1 1 1 1 1;0 0 0 0 0;-1 -1 -1 -1 -1];
ix = [-2 -1 0 1 2];
iy = ix';
Ixr = conv2(im_gray1,ix,'same');
Iy = conv2(im_gray1,iy,'same');
Ix2r = Ixr.^2;
Iy2r = Iy.^2;
Ixy = Ixr.*Iy;
figure()
imshow(Ixr)
title('Derivative applied in Horizontal Direction');
figure()
imshow(Iy)
title('Derivative applied in Vertical Direction');
ga = [exp(-2) exp(-1) 1 exp(-1) exp(-2)];
gau = (ga'*ga)/((2*pi));
ix2r = conv2(Ix2r,gau,'same');
iy2r = conv2(Iy2r,gau,'same');
ixyr = conv2(Ixy,gau,'same');
k = 0.05;
Hmaxr = 0; 
for i = 1:m
for j = 1:n
harrisr(i,j) = (ix2r(i,j)*iy2r(i,j) - (ixyr(i,j))^2) - k*(ix2r(i,j) + iy2r(i,j))^2;
if harrisr(i,j) > Hmaxr
Hmaxr = harrisr(i,j);
end;
end;
end;
ar = sum(sum((harrisr)));
ar = ar/(m*n);
cntr = 0;
metric1r = zeros(m,n);
for i = 3:m-2
for j = 3:n-2
if harrisr(i,j) > 0.005*Hmaxr && harrisr(i,j) > harrisr(i-1,j-1) && harrisr(i,j) > harrisr(i-1,j) && harrisr(i,j) > harrisr(i-1,j+1) && harrisr(i,j) > harrisr(i,j-1) && harrisr(i,j) > harrisr(i,j+1) && harrisr(i,j) > harrisr(i+1,j-1) && harrisr(i,j) > harrisr(i+1,j) && harrisr(i,j) > harrisr(i+1,j+1) && harrisr(i,j) > harrisr(i-2,j-2) && harrisr(i,j) > harrisr(i-2,j-1) && harrisr(i,j) > harrisr(i-2,j) && harrisr(i,j) > harrisr(i-2,j+1) && harrisr(i,j) > harrisr(i-2,j+2) && harrisr(i,j) > harrisr(i+2,j-2) && harrisr(i,j) > harrisr(i+2,j-1) && harrisr(i,j) > harrisr(i+2,j) && harrisr(i,j) > harrisr(i+2,j+1) && harrisr(i,j) > harrisr(i+2,j+2) && harrisr(i,j) > harrisr(i-1,j-2)  && harrisr(i,j) > harrisr(i,j-2) && harrisr(i,j) > harrisr(i+1,j-2) && harrisr(i,j) > harrisr(i-1,j+2)  && harrisr(i,j) > harrisr(i,j+2) && harrisr(i,j) > harrisr(i+1,j+2)   
resultr(i,j) = 1;
metric1r(i,j) = harrisr(i,j);

cntr = cntr+1;
end;
end;
end;
[pcr, prr] = find(resultr == 1);
cntr ;
g = uint8(resultr);
imshow(im_gray1);
hold on;
plot(prr,pcr,'r.');
title('Selected Features in Rotated Image');
hold off;

%%%ADAptive NMS
qr=1;
x_cordr = zeros(1,332);
y_cordr = zeros(1,332);
for i=1:size(metric1r,1)
    for j=1:size(metric1r,2)
        if(metric1r(i,j)~=0)
        metric1_array(qr)=metric1r(i,j);
        x_cordr(qr)=i;
        y_cordr(qr)=j;
        qr=qr+1;
        end
        
    end
end
%Arranging in decending order.
[Rr,ar]=sort(metric1_array,'descend');
        for i=1:size(ar,2)
            x_cord_newr(i)=x_cordr(ar(i));
            y_cord_newr(i)=y_cordr(ar(i));    
        end
        
%we need to take each non zero pixel and find the pixel that is k% greater than the pixel under consideration with the least distance between them.        
% let k=15%
k=25;
R_newr=0;
for i=2:size(Rr,2)
    min_distr=200;     %we need to take the max value
    for j=i-1:-1:1
        if(((Rr(j)-Rr(i))>(k*Rr(i)/100)))
            dist=sqrt((x_cord_newr(i)-x_cord_newr(j))^2+((y_cord_newr(i)-y_cord_newr(j))^2));
            if (dist<min_distr)
                min_distr=dist;
                if(R_newr==0)
                    R_newr(1)=max(max(Rr));
                    radiusr(1)=m*n;
                    x_cord_sortedr(1)=x_cord_newr(1);
                    y_cord_sortedr(1)=y_cord_newr(1);
                end
                R_newr(i)=Rr(j);
                radiusr(i)=min_distr;
                x_cord_sortedr(i)=x_cord_newr(i);
                y_cord_sortedr(i)=y_cord_newr(i);
            end
        end
    end                             
end

%now, we have the array sorted according to the raduis. we need to take top
%k values. Rest of the values will be 0. Convert it into matrix.
%top_n=5
top_n=150;
for i=top_n:size(R_newr,2)
    R_newr(i)=0;
end

final_mat_rotr=zeros(m,n);

for i=1:size(x_cord_newr,2)
    final_mat_rotr(x_cord_newr(i)+1,y_cord_newr(i)+1)=R_newr(i);
    if R_newr(i) == 0
       x_cord_newr(i) = 0;
       y_cord_newr(i) = 0;
   end
end
g1 = uint8(final_mat_rotr);

metric = harrisr;
% display('hello');
figure
imshow(uint8(final_mat_rotr));
figure;imshow(im_gray1);
hold on;
plot(y_cord_newr, x_cord_newr, 'rx');
title('Rotated ANMS');
hold off;


%%%%%%%%Finding SSN
%im_g = final_mat_rot;
im_g = imrotate(final_mat_rot,45);
im_g1 = final_mat_rotr;
[m1,n1] = size(im_g1);
mat = zeros(m1,n1);
cnt = 0;
dt = 1;
thresh = 1.8073e+20;
ssd1 = sum(sum((im_g1 - im_g).^2));
ssd = uint8(ssd1);
imshow(ssd,[])
for i = 1:m1
    for j = 1:n1
        ssd(i,j) = sum(sum((im_g1(i,j) - im_g(i,j))^2));
        if ssd(i,j)<=thresh && ssd(i,j) >0
            mat(i,j) = 1;
            cnt = cnt+1;
        end
    end
end
mata = imrotate(mat,-45);
[pc, pr] = find(mat == 1);
z1 = imrotate(im_gray,45);
z2 = imrotate(z1,-45);
figure()
imshow(z1,[])
hold on;
plot(pr,pc,'rx');
hold off;
title('Matched features in Original and Rotated ANMS');















