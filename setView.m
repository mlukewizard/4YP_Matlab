clc
clear
close all

import java.awt.Robot;
import java.awt.event.*;
mouse = Robot;

screenSize = get(0, 'screensize');

clickFirstIcon()

pause(0.1)
moveMouseTo(400,400)
pause(0.1)
press()
pause(0.1)
moveMouseTo(400,634)
pause(0.1)
release()
pause(0.1)
moveMouseTo(760,400)
pause(0.1)
press()
pause(0.1)
moveMouseTo(1146,400)
pause(0.1)
release()