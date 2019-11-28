clc
clear all;
close all;

%Read image
im = imread('Connected.bmp');
figure(1);
imshow(im,[]); %Display Text.bmp
title('Input image');
[m,n] = size(im);

%Thresholding

thresh = 50;
im_neg = zeros(m,n);
for i = 1:m
    for j = 1:n
if im(i,j)>thresh
    
    im_neg(i,j) = 0;
else
    
    im_neg(i,j) = 1;
end
    end
end
%Displaying thresholded image
figure(2)
imshow((im_neg),[]); 
title('Binary Image after thresholding');

%Generating null matrix to input connected component data into
conn = zeros(m,n);
%Counter to keep track of no.of connected components
conn_count = 1;
label = [1 : 1 : 10000];

for i = 1 : m
    for j = 1 : n
        if i == 1 && j == 1
                conn(i,j) = label(conn_count);
                conn_count = conn_count + 1;
        elseif im_neg(i,j) == 1
            if i == 1
                if im_neg(i,j-1) == 1
                    conn(i,j) = conn (i,j-1);
                else
                    conn(i,j) = label(conn_count);
                    conn_count = conn_count + 1;
                end
            elseif j == 1
                if im_neg(i-1,j) == 1
                    conn(i,j) = conn (i-1,j);
                else
                    conn(i,j) = label(conn_count);
                    conn_count = conn_count + 1;
                end
            else
                if im_neg(i-1,j) == 1 && im_neg(i,j-1) == 0
                    conn(i,j) = conn (i-1,j);
                elseif im_neg(i-1,j) == 0 && im_neg(i,j-1) == 1
                   conn(i,j) = conn (i,j-1);
                elseif im_neg(i-1,j) == 1 && im_neg(i,j-1) == 1
                    if conn(i-1,j) == conn(i,j-1)
                        conn(i,j) = conn (i-1,j);
                    else
                        conn(conn == conn(i-1,j)) = conn(i,j-1);
                        conn(i,j) = conn (i,j-1);
                    end
                else
                    conn(i,j) = label(conn_count);
                    conn_count = conn_count + 1;
                end
            end
        elseif im_neg(i,j) == 0
            if i == 1
                if im_neg(i,j-1) == 0
                    conn(i,j) = conn (i,j-1);
                else
                    conn(i,j) = label(conn_count);
                    conn_count = conn_count + 1;
                end
            elseif j == 1
                if im_neg(i-1,j) == 0
                    conn(i,j) = conn (i-1,j);
                else
                    conn(i,j) = label(conn_count);
                    conn_count = conn_count + 1;
                end
            else
                if im_neg(i-1,j) == 1 && im_neg(i,j-1) == 0
                    conn(i,j) = conn (i,j-1);
                elseif im_neg(i-1,j) == 0 && im_neg(i,j-1) == 1
                   conn(i,j) = conn (i-1,j);
                elseif im_neg(i-1,j) == 0 && im_neg(i,j-1) == 0
                    if conn(i-1,j) == conn(i,j-1)
                        conn(i,j) = conn (i,j-1);
                    else
                        conn(conn == conn(i-1,j)) = conn(i,j-1);
                        conn(i,j) = conn (i,j-1);
                    end
                else
                    conn(i,j) = label(conn_count);
                    conn_count = conn_count + 1;
                end
            end  
        end
    end
end

%Finding the dynamic range
diff2 = conn;
diff22 = (diff2-min(diff2(:)))/(max(diff2(:))-min(diff2(:)))*255;
figure(3)
imshow(diff2,[])
title('Connected Components Image in Full Dynamic Range');
