clc
clear
close all

import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;

screenSize = get(0, 'screensize');

clickFirstIcon()

pause(0.1)
moveMouseTo(400,300)
count = 3;
for i = 1:500
    pause(0.5)
   singleBackScroll()
   count = count + 1;
   if(count == 5)
       singleBackScroll()
       count = 1;
   end
   clc
   disp(i)
   sound(10000)
end