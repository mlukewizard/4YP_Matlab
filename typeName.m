function typeName(imgNum)
h = actxserver('WScript.Shell');

h.SendKeys('i');
h.SendKeys('n');
h.SendKeys('n');
h.SendKeys('e');
h.SendKeys('r');
h.SendKeys(imgNum);
end