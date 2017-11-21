function clickFirstIcon()
import java.awt.Robot;
import java.awt.event.*;

mouse = Robot;

mouse.waitForIdle
mouse.mouseMove(470, 750);
mouse.waitForIdle
mouse.mousePress(InputEvent.BUTTON1_MASK);
mouse.waitForIdle
mouse.mouseRelease(InputEvent.BUTTON1_MASK);
end