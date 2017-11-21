function closeWindow()
h = actxserver('WScript.Shell');

h.SendKeys('%{F4}');
end