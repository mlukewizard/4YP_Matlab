clc
clear
close all

images = ["C:\Users\Luke\Documents\sharedFolder\4YP\Images\Luke_MH\preAugmentation\dicoms\IMG00300"
    "C:\Users\Luke\Documents\sharedFolder\4YP\Images\Luke_MH\preAugmentation\dicoms\IMG00305"
    "C:\Users\Luke\Documents\sharedFolder\4YP\Images\Luke_MH\preAugmentation\dicoms\IMG00310"
    "C:\Users\Luke\Documents\sharedFolder\4YP\Images\Luke_MH\preAugmentation\dicoms\IMG00315"
    "C:\Users\Luke\Documents\sharedFolder\4YP\Images\Luke_MH\preAugmentation\dicoms\IMG00320"];
for i = 1:1
myImage = dicomread(char(images(i)));
A = double(myImage)./double(max(myImage(:)));
[X, Y] = meshgrid(1:size(A,1), 1:size(A,2));
imshow(A)
Z1 = ones(size(A))*i*500;
for k = 1:size(Z1)
    for j = 1:size(Z1)
        distance = (k-300)^2 + (j-256)^2;
        if distance < 1000
            Z1(k, j) = (1000 -1*(distance))/1000;
        else
            Z1(k, j) = 0;
        end
        
    end
end
surf(X,Y,Z1);
hold on
end
axis([0, 512, 0, 512])

shading interp