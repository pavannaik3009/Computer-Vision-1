clc;
clear all;
close all;

im = imread('Image.bmp');
kernel = ones(5, 5);
W=25;	% sum of elements of kernel(for normalization)

kernel = kernel/W;

[m,n] = size(im);
output = zeros(m,n);
Im = padarray(im, [2,2]);

for i=1:m
	for j = 1:n
		temp = Im(i:i+4, j:j+4);
		temp = double(temp);
		conv = temp.*kernel;
		output(i, j) = sum(conv(:));
	end
end
output = uint8(output);
figure(1)
subplot(121),imshow(im),title('Input Image');
subplot(122),imshow(output),title('Moving Average Filter Output Image');