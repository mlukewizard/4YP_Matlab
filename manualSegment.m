clc
clear 
close all

dicomFiles = 'C:\Users\Luke\Downloads\Download+TP3+cases\21-27_processed\S1-27_axial\';
imageSaveDir = 'C:\\Users\\Luke\\Downloads\\Download+TP3+cases\\minedImages\\';
imageType = "inner";
figure
set(gcf,'Pointer','crosshair');

files = orderfields(dir(dicomFiles));
files = files(arrayfun(@(x) strlength(string(x.name)), files) > 3);

for i = 1:length(files)
    file = files(i);
    splittedWriteName = strsplit(file.name, '.');
    dicomFileNum = splittedWriteName(1);
    dicomFileNum = char(dicomFileNum);
    dicomFileNum = str2double(string(dicomFileNum(end-2:end)));
    if dicomFileNum > 270
        disp("Segmenting Image " + string(dicomFileNum))
        dicomImage = mat2gray(dicomread(horzcat(dicomFiles, file.name)));
        imshow(dicomImage, 'Parent', gca)
        searchingForContour = true;
        xPoints = [];
        yPoints = [];
        while searchingForContour
            k = waitforbuttonpress;
            mouseClickPoint = get(gca,'CurrentPoint');
            keyPressType = get(gcf,'SelectionType');
            
            % No aneurysm here
            if k == 1
               searchingForContour = false;
               imwrite(zeros(512), char(string(imageSaveDir) + string(splittedWriteName(1)) + imageType + ".png"));
               
            % Automatic thresholding
            elseif string(keyPressType) == "alt"
                workingImage = dicomImage;
                x = mouseClickPoint(1,1);
                y = mouseClickPoint(1,2);
                workingImage = imgaussfilt(workingImage, 1);
                gradient = imgradient(workingImage);
                gradient = imgaussfilt(gradient, 1);
                gradient = medfilt2(gradient);
                newGrad = zeros(512);
                
                %weighting pixel intensity by distance
                for i1 = 1:512
                    for j = 1:512
                        distance = (j-x)^2 + (i1-y)^2;
                        if distance < 10
                            newGrad(i1,j) = 0;
                        else
                            newGrad(i1,j) = gradient(i1,j) / (0.1*(distance^0.4));
                        end
                    end
                end
                
                gradient = medfilt2(gradient);
                gradient = medfilt2(gradient);
                gradient = im2bw(gradient, 0.1);
                labels = bwlabel(imcomplement(gradient), 4);
                labels(labels~=labels(int16(y),int16(x))) = 0;
                labels = bwperim(labels);
                
                %Successively getting outer perimeter
                for k = 1:3
                    labels = bwperim(imcomplement(labels));
                    se = strel('disk', 2, 0);
                    labels = imclose(labels, se);
                    labels = imclearborder(labels);
                    labels = imfill(labels, 'holes');
                    labels = bwperim(labels);
                end
                
                [x, y, z] = find(labels);
                clf
                imshow(dicomImage)
                hold on
                scatter(y,x, 1, '.')
                waitforbuttonpress;
                keyPressType = get(gcf,'SelectionType');
                mouseClickPoint = get(gca,'CurrentPoint');
                if string(keyPressType) == "open" || string(keyPressType) == "extend"
                    imshow(dicomImage)
                elseif string(keyPressType) == "alt"
                    %Doing the second threshold
                    workingImage = dicomImage;
                    x2 = mouseClickPoint(1,1);
                    y2 = mouseClickPoint(1,2);
                    workingImage = imgaussfilt(workingImage, 1);
                    gradient = imgradient(workingImage);
                    gradient = imgaussfilt(gradient, 1);
                    gradient = medfilt2(gradient);
                    newGrad = zeros(512);

                    %weighting pixel intensity by distance
                    for i1 = 1:512
                        for j = 1:512
                            distance = (j-x2)^2 + (i1-y2)^2;
                            if distance < 10
                                newGrad(i1,j) = 0;
                            else
                                newGrad(i1,j) = gradient(i1,j) / (0.1*(distance^0.4));
                            end
                        end
                    end

                    gradient = medfilt2(gradient);
                    gradient = medfilt2(gradient);
                    gradient = im2bw(gradient, 0.1);
                    labels2 = bwlabel(imcomplement(gradient), 4);
                    labels2(labels2~=labels2(int16(y2),int16(x2))) = 0;
                    labels2 = bwperim(labels2);

                    %Successively getting outer perimeter
                    for k = 1:3
                        labels2 = bwperim(imcomplement(labels2));
                        se = strel('disk', 2, 0);
                        labels2 = imclose(labels2, se);
                        labels2 = imclearborder(labels2);
                        labels2 = imfill(labels2, 'holes');
                        labels2 = bwperim(labels2);
                    end
                    [x2, y2, z2] = find(labels2);
                    clf
                    imshow(dicomImage)
                    hold on
                    scatter(y,x, 1, '.')
                    scatter(y2,x2, 1, '.')
                    waitforbuttonpress;
                    keyPressType = get(gcf,'SelectionType');
                    if string(keyPressType) == "open" || string(keyPressType) == "extend"
                        imshow(dicomImage)
                    else
                        searchingForContour = false;
                        imwrite(imfill(labels, 'holes') + imfill(labels2, 'holes'), char(string(imageSaveDir) + string(splittedWriteName(1)) + imageType + ".png"));
                    end
                        
                else
                    searchingForContour = false;
                    imwrite(imfill(labels, 'holes'), char(string(imageSaveDir) + string(splittedWriteName(1)) + imageType + ".png"));
                end
            %Youre plotting points
            else
                plottingPoints = true;
                iteration = 0;
                while plottingPoints
                    iteration = iteration + 1;
                    if iteration == 1
                        x = mouseClickPoint(1,1);
                        y = mouseClickPoint(1,2);
                    else
                        k = waitforbuttonpress;
                        mouseClickPoint = get(gca,'CurrentPoint');
                        keyPressType = get(gcf,'SelectionType');
                        x = mouseClickPoint(1,1);
                        y = mouseClickPoint(1,2);
                    end
                    xPoints = [xPoints, x];
                    yPoints = [yPoints, y];
                    clf
                    imshow(dicomImage)
                    hold on
                    scatter(xPoints, yPoints, '.')
                    if string(keyPressType) == "alt"
                        spcv = cscvn([[xPoints, xPoints(1)]; [yPoints, yPoints(1)]]); 
                        hold on
                        before = findall(gca);
                        fnplt(spcv)
                        added = setdiff(findall(gca), before);
                        set(added, 'Color', [1 1 1]); set(added, 'LineWidth', 1)
                        waitforbuttonpress;
                        keyPressType = get(gcf,'SelectionType');
                        mouseClickPoint = get(gca,'CurrentPoint');
                        if string(keyPressType) == "open" || string(keyPressType) == "extend"
                            plottingPoints = false;
                            imshow(dicomImage)
                            xPoints = [];
                            yPoints = [];
                        elseif string(keyPressType) == "normal"
                            iteration2 = 0;
                            x2 = mouseClickPoint(1,1);
                            y2 = mouseClickPoint(1,2);
                            xPoints2 = [x2];
                            yPoints2 = [y2];
                            while plottingPoints
                                iteration2 = iteration2 + 1;
                                if iteration2 == 1
                                    x2 = mouseClickPoint(1,1);
                                    y2 = mouseClickPoint(1,2);
                                else
                                    k = waitforbuttonpress;
                                    mouseClickPoint = get(gca,'CurrentPoint');
                                    keyPressType = get(gcf,'SelectionType');
                                    x2 = mouseClickPoint(1,1);
                                    y2 = mouseClickPoint(1,2);
                                end
                                xPoints2 = [xPoints2, x2];
                                yPoints2 = [yPoints2, y2];
                                clf
                                imshow(dicomImage)
                                hold on
                                scatter(xPoints2, yPoints2, '.')
                                if string(keyPressType) == "alt"
                                    spcv1 = cscvn([[xPoints, xPoints(1)]; [yPoints, yPoints(1)]]);
                                    hold on
                                    before = findall(gca);
                                    fnplt(spcv1)
                                    added = setdiff(findall(gca), before);
                                    set(added, 'Color', [1 1 1]); set(added, 'LineWidth', 1)
                                    spcv2 = cscvn([[xPoints2, xPoints2(1)]; [yPoints2, yPoints2(1)]]); 
                                    hold on
                                    before = findall(gca);
                                    fnplt(spcv2)
                                    added = setdiff(findall(gca), before);
                                    set(added, 'Color', [1 1 1]); set(added, 'LineWidth', 1)
                                    waitforbuttonpress;
                                    keyPressType = get(gcf,'SelectionType');
                                    if string(keyPressType) == "open" || string(keyPressType) == "extend"
                                        plottingPoints = false;
                                        imshow(dicomImage)
                                        xPoints = [];
                                        yPoints = [];
                                        xPoints2 = [];
                                        yPoints2 = [];
                                    else
                                        plottingPoints = false;
                                        searchingForContour = false;
                                        clf
                                        imshow(zeros(512))
                                        hold on
                                        spcv = cscvn([[xPoints, xPoints(1)]; [yPoints, yPoints(1)]]);
                                        before = findall(gca);
                                        fnplt(spcv)
                                        added = setdiff(findall(gca), before);
                                        set(added, 'Color', [1 1 1])
                                        set(added, 'LineWidth', 1)
                                        set(gca,'Color','k')
                                        axis([1, 512, 1, 512])
                                        iptsetpref('ImshowBorder','tight');
                                        axis off
                                        figureImage1 = getframe(gcf);
                                        figureImage1 = imbinarize(rgb2gray(figureImage1.cdata));
                                        figureImage1 = imfill(figureImage1, 'holes');
                                        
                                        clf
                                        imshow(zeros(512))
                                        hold on
                                        spcv = cscvn([[xPoints2, xPoints2(1)]; [yPoints2, yPoints2(1)]]);
                                        before = findall(gca);
                                        fnplt(spcv)
                                        added = setdiff(findall(gca), before);
                                        set(added, 'Color', [1 1 1])
                                        set(added, 'LineWidth', 1)
                                        set(gca,'Color','k')
                                        axis([1, 512, 1, 512])
                                        iptsetpref('ImshowBorder','tight');
                                        axis off
                                        figureImage2 = getframe(gcf);
                                        figureImage2 = imbinarize(rgb2gray(figureImage2.cdata));
                                        figureImage2 = imfill(figureImage2, 'holes');
                                        
                                        figureImage = figureImage2 + figureImage1;
                                        imwrite(figureImage, char(string(imageSaveDir) + string(splittedWriteName(1)) + imageType + ".png"));
                                    end
                                end
                            end
                        else
                            plottingPoints = false;
                            searchingForContour = false;
                            clf
                            imshow(zeros(512))
                            hold on
                            spcv = cscvn([[xPoints, xPoints(1)]; [yPoints, yPoints(1)]]);
                            before = findall(gca);
                            fnplt(spcv)
                            added = setdiff(findall(gca), before);
                            set(added, 'Color', [1 1 1])
                            set(added, 'LineWidth', 1)
                            set(gca,'Color','k')
                            axis([1, 512, 1, 512])
                            iptsetpref('ImshowBorder','tight');
                            axis off
                            figureImage = getframe(gcf);
                            figureImage = imbinarize(rgb2gray(figureImage.cdata));
                            figureImage = imfill(figureImage, 'holes');
                            imwrite(figureImage, char(string(imageSaveDir) + string(splittedWriteName(1)) + imageType + ".png"));
                        end
                    end
                end
            end
        end
    end
end
close all
