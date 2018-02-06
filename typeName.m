function typeName(imgNum, imageType)
h = actxserver('WScript.Shell');

if imageType == 'inner'
    h.SendKeys('i');
    h.SendKeys('n');
    h.SendKeys('n');
elseif imageType == 'outer'
    h.SendKeys('o');
    h.SendKeys('u');
    h.SendKeys('t');
    else
        disp('Youve passed the wrong value in')
end
h.SendKeys('e');
h.SendKeys('r');
h.SendKeys(imgNum);
end