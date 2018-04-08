clc
clear
close all

patientID = 'AA';

caseFolder = horzcat('C:\Users\Luke\Documents\sharedFolder\4YP\Images\Luke_', patientID, '\postAugmentation\');
croppedDicomFolder = horzcat(caseFolder, 'croppedDicoms\');
outerAugFolder = horzcat(caseFolder, 'outerAugmented\');
innerAugFolder = horzcat(caseFolder, 'innerAugmented\');

%{
caseFolder = 'C:\Users\Luke\Documents\sharedFolder\4YP\Images\Luke_DC\preAugmentation\';
croppedDicomFolder = horzcat(caseFolder, 'dicoms\');
outerAugFolder = horzcat(caseFolder, 'outerBinary\');
innerAugFolder = horzcat(caseFolder, 'innerBinary\');
%}

dicomFiles = orderfields(dir(croppedDicomFolder));
innerFiles = orderfields(dir(innerAugFolder));
outerFiles = orderfields(dir(outerAugFolder));

dicomFiles = dicomFiles(arrayfun(@(x) strlength(string(x.name)), dicomFiles) > 3);
innerFiles = innerFiles(arrayfun(@(x) strlength(string(x.name)), innerFiles) > 3);
outerFiles = outerFiles(arrayfun(@(x) strlength(string(x.name)), outerFiles) > 3);


for i = 200:length(dicomFiles)
    dicomFile = imread(horzcat(croppedDicomFolder, dicomFiles(i).name));
    %dicomFile = mat2gray(dicomread(horzcat(croppedDicomFolder, dicomFiles(i).name)));
    hold on
    innerFile = bwperim(imread(horzcat(innerAugFolder, innerFiles(i).name)));
    innerFileOverlayed = imoverlay(dicomFile, innerFile);
    outerFile = bwperim(imread(horzcat(outerAugFolder, outerFiles(i).name)));
    outerFileOverlayed = imoverlay(dicomFile, outerFile);
    clc
    close all
    disp(dicomFiles(i).name)
    disp(innerFiles(i).name)
    disp(outerFiles(i).name)
    if mod(i, 2) == 0
        disp("inner")
    	imshow(innerFileOverlayed)
    end
    if mod(i, 2) == 1
        disp("Outer")
    	imshow(outerFileOverlayed)
    end
    pause(0.9)
    
    
end
