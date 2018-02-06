clc
clear
close all

x = linspace(0, 255)

%y = 135.6*tanh((x-150)/70) + 132
y = 135.78315*tanh((x-150)/70) + 132.0961

plot(x, y)

axis([0,255,0,255])