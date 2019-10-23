clc;
clear all;
close all;


im = imread('Image.bmp');
[m,n] = size(im);
output = zeros(m,n);
Im = padarray(im, [2,2]);
kernel = [0.003 0.0133 0.0219 0.0133 0.003; 0.0133 0.0596 0.0983 0.0596 0.0133; 0.0219 0.0983 0.1621 0.0983 0.0219;
		  0.0133 0.0596 0.0983 0.0596 0.0133; 0.003 0.0133 0.0219 0.0133 0.003]; %kernel calculated from question 1
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
subplot(122),imshow(output),title('Gaussian Filtered Output Image');