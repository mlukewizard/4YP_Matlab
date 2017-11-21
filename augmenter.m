clc
clear
close all

%Set read and write directories for the images
binaryReadDir = 'C:\Users\Luke\Documents\sharedFolder\Images\39894NS\PreAugmentation\goodInnerImagesBinaryLessBlack\';
binaryWriteDir = 'C:\Users\Luke\Documents\sharedFolder\Images\39894NS\256\PostAugmentation\augmentedInnerBinary\';
dicomReadDir = 'C:\Users\Luke\Documents\sharedFolder\Images\39894NS\PreAugmentation\innerDicomsLessBlack\';
dicomWriteDir = 'C:\Users\Luke\Documents\sharedFolder\Images\39894NS\256\PostAugmentation\augmentedInnerOriginals\';

augmented = true;

files = dir(binaryReadDir);
averageTime = 0;

counter = 0;
tic

augNum = 2;
for i = 1:augNum
    
    %contrast adjustment parameters
    upper = 0; lower = 0;
    while upper-lower < 0.4
        lower = rand();
        upper = rand();
    end
    
    %Shear adjustment parameters
    IshearVal = 0.6*(rand()-0.5);
    tform = affine2d([1 0 0; IshearVal 1 0; 0 0 1]);
    
    trueFileNum = 0;
    for file = files'
        %the if is needed because . and .. come up for some reason
        if length(file.name) > 2
            trueFileNum = trueFileNum + 1;
            newFileName = file.name;
            splitted = split(newFileName, 'Binary.png');
            firstHalf = splitted(1);
            splitted2 = split(firstHalf, 'inner');
            imageNumber = char(splitted2(2));
            
            binaryFilename = file.name;
            binaryFilepath = horzcat(binaryReadDir, binaryFilename);
            
            dicomFilename = horzcat('IMG00', imageNumber);
            dicomFilepath = horzcat(dicomReadDir, dicomFilename);
            
            % Read it in to a variable
            binaryImage = imread(binaryFilepath);
            dicomImage = dicomread(dicomFilepath);
            
            if augmented == true
                %Contrast adjustment
                dicomImage = imadjust(dicomImage, stretchlim(dicomImage),[lower,upper]);
                
                %Rotate image
                %IrotationAngle = round(5*(rand()-0.5));
                %dicomImage = imrotate(dicomImage , IrotationAngle);
                %binaryImage = imrotate(binaryImage , IrotationAngle);
                
                %Shear image
                dicomImage = imwarp(dicomImage,tform, 'FillValues',dicomImage(512,512));
                binaryImage = imwarp(binaryImage,tform,'FillValues',0);
                
                %Scale image
                %scale = rand();
                %binaryImage = imresize(binaryImage,scale);
                %dicomImage = imresize(dicomImage,scale);
                
                %Takes the middle 512 pixels
                [nl, nc, ~] = size(dicomImage);
                %dicomImage = dicomImage(:, round(nc/2-256):round(nc/2-256)+511);
                %binaryImage = binaryImage(:, round(nc/2-256):round(nc/2-256)+511);
                dicomImage = dicomImage(round(nl/2-128):round(nl/2-128)+255, round(nc/2-128):round(nc/2-128)+255);
                binaryImage = binaryImage(round(nl/2-128):round(nl/2-128)+255, round(nc/2-128):round(nc/2-128)+255);
            else
                dicomImage = imadjust(dicomImage, stretchlim(dicomImage),[0,1]);
            end
            
            %change matrix type
            uint8dicomImage = zeros(size(dicomImage),'uint8');
            uint8dicomImage = changeArray(dicomImage, uint8dicomImage);
            
            %close all
            %subplot(1,2,1), imshow(dicomImage)
            %subplot(1,2,2), imshow(binaryImage)
            %drawnow
            %pause(1)
            
            binaryWritename = horzcat('Augment', sprintf('%03d',i) , 'Binary', sprintf('%03d',trueFileNum), 'PatientNS', '.png');
            originalWritename = horzcat('Augment', sprintf('%03d',i) , 'Original', sprintf('%03d',trueFileNum), 'PatientNS', '.png');
            imwrite(uint8dicomImage, horzcat(dicomWriteDir, originalWritename),'png');
            imwrite(binaryImage, horzcat(binaryWriteDir, binaryWritename),'png');
            counter = counter + 1;
        end
        averageTime = toc/counter;
        ETA = ((augNum*(length(files')-2))-counter)*averageTime;
        if (~rem(counter,10)*counter/10)~= 0
            clc
            fprintf("Iteration " + counter + "/" + (length(files')-2)*augNum + ". ETA = " + ETA + "\n");
        end
    end
end

function anotherArray = changeArray(inputArray, anotherArray)
s = size(inputArray);
for i = 1:s(1)
    for j = 1:s(2)
        anotherArray(i,j) = round(inputArray(i,j)*(127/32767))+127;
    end
end
end
