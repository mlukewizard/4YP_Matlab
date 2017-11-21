function selectSection2()
import java.awt.Robot;
import java.awt.event.*;

mouse = Robot;
startx = 424;
starty = 117;
mouse.waitForIdle
mouse.mouseMove(startx, starty);
mouse.waitForIdle
mouse.mousePress(InputEvent.BUTTON1_MASK);
mouse.waitForIdle
mouse.mouseMove(startx+511, starty+511);
mouse.waitForIdle
mouse.mouseRelease(InputEvent.BUTTON1_MASK);
end