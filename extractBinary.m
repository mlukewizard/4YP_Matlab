clc
clear
close all

writeDir = 'C:\Users\Luke\Documents\sharedFolder\Images\39894NS\PreAugmentation\innerBinary\';
fileDir = 'C:\Users\Luke\Documents\sharedFolder\Images\39894NS\PreAugmentation\innerImagesSegment\';

files = dir(fileDir);
loopCount = 0;

for file = files'
     
    %if needed because . and .. come up for some reason 
    if length(file.name) > 2
        loopCount = loopCount + 1;

        newFileName = file.name;
        split1 = split(newFileName, '.PNG');
        firstHalf = split1(1);
        split2 = split(firstHalf, 'inner');
        split2 = split2(2);
        imageNumber = str2num(cell2mat(split2));
        rootString = horzcat('inner',sprintf('%03d',imageNumber));
        newFileName = horzcat(rootString, 'Binary.png');
        
        filename = horzcat(fileDir,file.name);
        disp(filename);
        
        % Read it in to a variable
        myImage = imread(filename);
        greyImage = rgb2gray(myImage);
        
        BW = imbinarize(greyImage, 0.999);
        %BW = bwareaopen(BW, 50);
        se = strel('disk',8);binaryImage = imclose(BW,se);
        binaryImage = imfill(binaryImage, 'holes');
        
        binaryImage = bwareaopen(binaryImage, 600);
        %imshow(binaryImage)
        
        % Save the image to a file on my local hard drive.        
        binaryImage = im2uint8(binaryImage);
        
        imwrite(binaryImage, horzcat(writeDir, newFileName),'png');
        
        clc
        disp("image " + loopCount)
    end
end
