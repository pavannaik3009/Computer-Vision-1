clc;
clear all;
close all;

%coordinates of the equilateral triangle
fig = [1 2 3 1;1 2.73 1 1];

%%Translation of an equilateral triangle

%Creating [I t] for equation p'=[I t]p
%Assigning values for t1 and t2 
t1=3;
t2=4;
It1=[1 0 t1;0 1 t2;0 0 1];
augv= [fig;1 1 1 1 ]  %augmented vector
tra= It1*augv
%Homogenous coorinates vertices
z = 3;
thom = z*tra 

figure(1)
plot(fig(1,1:end),fig(2,1:end),'bx-');
axis([0 10 0 10])

%Plotting 2D Translation
hold on
plot(tra(1,1:end),tra(2,1:end),'kx-');
axis([0 10 0 10])
title("2D Translation");
xlabel("X-axis");
ylabel("Y-axis");
legend('Original','Transformed');
grid on;
hold off



%%Rotation of an equilateral triangle

%Formula for rotation is p'= [R t]*augv
% assuming angle of rotation as 30 degrees
Rt = [cos(30) -sin(30) t1; sin(30) cos(30) t2; 0 0 1];
rot = Rt*augv

rhom = z*rot

figure(2)
plot(fig(1,1:end),fig(2,1:end),'bx-');
axis([0 5 0 5])

%Plotting 2D Rotation
hold on
plot(rot(1,1:end),rot(2,1:end),'kx-');
axis([0 10 0 10])
title("2D Rotation");
xlabel("X-axis");
ylabel("Y-axis");
legend('Original','Transformed');
grid on;
hold off


%%Similarity Transformation of an equilateral triangle
%Assuming  a=0.3 and b=0.4, equation is p' = SR*p + t
a= 0.3;
b= 0.4;
SRt = [a -b t1; b a t2; 0 0 1]
simt = SRt*augv

sthom = z*simt

figure(3)
plot(fig(1,1:end),fig(2,1:end),'bx-');

%Plotting 2D Similarity Transform
hold on
plot(simt(1,1:end),simt(2,1:end),'kx-');
axis([0 10 0 10])
title("Similarity Transform");
xlabel("X-axis");
ylabel("Y-axis");
legend('Original','Transformed');
grid on;
hold off


%% Affine Transformation of Equilateral triangle
%Equation is p' = A.augv where A is an arbitrary matrix of size 2x3
A = [0.2 2 0.3;0.5 0.4 0.3];
at = A*augv
athom = z*at

figure(4)
plot(fig(1,1:end),fig(2,1:end),'bx-');
axis([0 10 0 10])

%Plotting 2D Affine Transform
hold on
plot(at(1,1:end),at(2,1:end),'kx-');
title("Affine Transform");
axis([0 10 0 10])
xlabel("X-axis");
ylabel("Y-axis");
legend('Original','Transformed');
grid on;
hold off


%Projective Transformation of an Equilateral Triangle
%Equation is p~'=H~*p
H = [.2 .3 .4;.5 .6 .7;.8 .9 1];
%Homogenous Coordinates.
pthom= H*augv     


%Inhomogenous Coordinates
pt = [pthom(1,1:4)./(pthom(3,1:4));pthom(2,1:4)./(pthom(3,1:4));pthom(3,1:4)./(pthom(3,1:4))]   

figure(5)
plot(fig(1,1:end),fig(2,1:end),'bx-');

hold on
plot(pthom(1,1:end),pthom(2,1:end),'kx-');
axis([0 10 0 10])
title("Projective Transform");
xlabel("X-axis");
ylabel("Y-axis");
legend('Original','Transformed');
grid on;