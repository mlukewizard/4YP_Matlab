clc
clear
close all

f.Color = 'white';
ax = gca;
ax.XAxisLocation = 'bottom';
ax.YAxisLocation = 'left';

plot([0,255], [0,255])
axis([0, 255, 0, 255])
xlabel('I')
ylabel('I''')


scatter([0, 255], [0, 255], 'x')
hold on
errorbar([85, 170], [85, 170], [30, 30], 'LineStyle','none');
x = linspace(0, 255);
y = 0.2560025*x + 0.007920138*x.^2 - 0.00001961765*x.^3;
plot(x,y)
axis([0, 255, 0, 255])
xlabel('I')
ylabel('I''')
