function clickNew()
import java.awt.Robot;
import java.awt.event.*;

mouse = Robot;

mouse.waitForIdle
mouse.mouseMove(550, 250);
mouse.waitForIdle
mouse.mousePress(InputEvent.BUTTON1_MASK);
mouse.waitForIdle
mouse.mouseRelease(InputEvent.BUTTON1_MASK);
end