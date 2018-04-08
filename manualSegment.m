clc
clear 
close all

dicomFiles = 'C:\Users\Luke\Documents\sharedFolder\4YP\interObserver\randomSlices\AD\';
imageSaveDir = 'C:\Users\Luke\Documents\sharedFolder\4YP\interObserver\randomSlices\AD\regent\';
if (exist(imageSaveDir) == 0)
    mkdir(imageSaveDir)
end
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
    if dicomFileNum > 275
        disp("Segmenting Image " + string(dicomFileNum))
        dicomImage = mat2gray(dicomread(horzcat(dicomFiles, file.name)));
        imshow(dicomImage, 'Parent', gca)
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
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
               
            
            elseif string(keyPressType) == "alt"
                %Automatic thresholding
                workingImage = dicomImage;
                x = int16(mouseClickPoint(1,1));
                y = int16(mouseClickPoint(1,2));

                workingImage = imgaussfilt(workingImage, 1);
                gradient = im2bw(workingImage, workingImage(y,x)-0.04);
                labels = bwlabel(gradient, 4);
                labels(labels~=labels(int16(y),int16(x))) = 0;
                labels = bwperim(labels);

                [x, y, z] = find(labels);
                clf
                imshow(dicomImage)
                set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
                hold on
                scatter(y,x, 1, '.')
                waitforbuttonpress;
                keyPressType = get(gcf,'SelectionType');
                mouseClickPoint = get(gca,'CurrentPoint');
                if string(keyPressType) == "open" || string(keyPressType) == "extend"
                    imshow(dicomImage)
                    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
                elseif string(keyPressType) == "alt"
                    %Doing the second threshold
                    workingImage = dicomImage;
                    x2 = int16(mouseClickPoint(1,1));
                    y2 = int16(mouseClickPoint(1,2));
                    
                workingImage = imgaussfilt(workingImage, 1);
                gradient = im2bw(workingImage, workingImage(y2,x2)-0.04);
                labels2 = bwlabel(gradient, 4);
                labels2(labels2~=labels2(int16(y2),int16(x2))) = 0;
                labels2 = bwperim(labels2);
                
                    [x2, y2, z2] = find(labels2);
                    clf
                    imshow(dicomImage)
                    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
                    hold on
                    scatter(y,x, 1, '.')
                    scatter(y2,x2, 1, '.')
                    waitforbuttonpress;
                    keyPressType = get(gcf,'SelectionType');
                    if string(keyPressType) == "open" || string(keyPressType) == "extend"
                        imshow(dicomImage)
                        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
                    else
                        searchingForContour = false;
                        imwrite(imfill(labels, 'holes') + imfill(labels2, 'holes'), char(string(imageSaveDir) + string(splittedWriteName(1)) + imageType + ".png"));
                    end
                        
                else
                    searchingForContour = false;
                    imwrite(imfill(labels, 'holes'), char(string(imageSaveDir) + string(splittedWriteName(1)) + imageType + ".png"));
                end
            %Youre plotting points
            elseif string(keyPressType) ~= "extend"
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
                    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
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
                            set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
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
                                set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
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
                                        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
                                        xPoints = [];
                                        yPoints = [];
                                        xPoints2 = [];
                                        yPoints2 = [];
                                    else
                                        plottingPoints = false;
                                        searchingForContour = false;
                                        clf
                                        imshow(zeros(512))
                                        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
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
                                        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
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
                            set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
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
