clc
clear
close all

imageType = 'inner'
patientID = 'PS'
writeDir = horzcat('C:\Users\Luke\Documents\sharedFolder\4YP\Images\Regent_', patientID, '\preAugmentation\', imageType, 'Binary\');
fileDir = horzcat('C:\Users\Luke\Documents\sharedFolder\4YP\Images\Regent_', patientID, '\preAugmentation\', imageType, 'ImagesSegment\');
binaryType = 'outer';

files = dir(fileDir);
loopCount = 0;

for file = files'
     
    %if needed because . and .. come up for some reason 
    if contains(file.name, 'er')
        loopCount = loopCount + 1;

        newFileName = file.name;
        split1 = split(newFileName, '.PNG');
        firstHalf = split1(1);
        split2 = split(firstHalf, 'er');
        split2 = split2(2);
        imageNumber = str2num(cell2mat(split2));
        rootString = horzcat(binaryType,sprintf('%03d',imageNumber));
        newFileName = horzcat(rootString, 'Binary.png');
        
        filename = horzcat(fileDir,file.name);
        disp(filename);
        
        % Read it in to a variable
        myImage = imread(filename);
        greyImage = rgb2gray(myImage);
        
        BW = imbinarize(greyImage, 0.999);
        %BW = bwareaopen(BW, 50);
        se = strel('disk',10);
        
        %For PS Outer
        %special cases
        %if (imageNumber == 152)||(imageNumber == 280)||(imageNumber == 94)
        %    se = strel('disk',20);
        %elseif (imageNumber == 367) || (imageNumber == 327)
        %    se = strel('disk',40);
        %elseif (367 < imageNumber)
        %    se = strel('disk',30);
        %end
        
        binaryImage = imclose(BW,se);
        binaryImage = imfill(binaryImage, 'holes');
        
        binaryImage = bwareaopen(binaryImage, 450);
        %imshow(binaryImage)
        
        % Save the image to a file on my local hard drive.        
        binaryImage = im2uint8(binaryImage);
        
        imwrite(binaryImage, horzcat(writeDir, newFileName),'png');
        
        clc
        disp("image " + loopCount)
    end
end
