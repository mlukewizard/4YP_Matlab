clc
clear
close all

import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;

screenSize = get(0, 'screensize');
imageType = 'inner';

clickFirstIcon()
mouse.mouseMove(720, 380);

count = 2;
totalCount = 0;
for i = 1:450
    pause(0.1)
    clickSecondIcon()
    pause(0.3)
    clickNew()
    pause(0.5)
    selectSection2()
    pause(0.2)
    %dont need to wait here
    closeWindow()
    pause(0.5)
    clickYes()
    %dont need to wait here
    imgNum = char(int2str(i));
    pause(0.5)    
    typeName(imgNum, imageType)
    pause(0.01)
    clickSave()
    pause(0.6)
    singleBackScroll()
    %{
    count = count + 1;
    if totalCount == 7
        pause(0.05)
        singleBackScroll()
        count = 0;
    end
    if (count == 4)
        pause(0.05)
        singleBackScroll()
        count = 0;
    end
    %}
    clc
    disp(i)
end
