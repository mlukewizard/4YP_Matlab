clc
clear
close all

import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;

screenSize = get(0, 'screensize');

clickFirstIcon()

count = 3;
for i = 1:501
    pause(0.2)
    clickSecondIcon()
    pause(0.5)
    clickNew()
    pause(0.5)
    selectSection2()
    pause(0.2)
    %dont need to wait here
    closeWindow()
    pause(0.5)
    clickYes()
    pause(0.2)
    %dont need to wait here
    imgNum = char(int2str(i));
    typeName(imgNum)
    clickSave()
    pause(0.7)
    singleBackScroll()
    count = count + 1;
    if(count == 5)
        pause(0.05)
        singleBackScroll()
        count = 1;
    end
    clc
    disp(i)
end
