clc
clear all
close all
%Fwd Kinematics of 1 DOF
%Given
L1 = 10e-2; %m
L2 = 10e-2;
y = 15e-2;

for x = -13e-2:10e-4:13e-2
    
    theta2 = atan2d(sqrt(1-((x*x+y*y-L1*L1-L2*L2)/(2*L1*L2))^2),(x*x+y*y-L1*L1-L2*L2)/(2*L1*L2));

    k1 = L2*cosd(theta2) + L1
    k2 = L2*sind(theta2)
    theta1 = atan2d(y,x) - atan2d(k2, k1);
    
    x1= L1 * cosd(theta1);
    y1= L1 * sind(theta1);

    LineXCood1= [0 x1];
    LineYCood1= [0 y1];
    
    %theta2 = 30;
    x2= L2 * cosd(theta2 + theta1);
    y2= L2 * sind(theta2 + theta1);

    %LineXCood2= [x1 L1*cosd(theta1)+L2*cosd(theta2)];
    %LineYCood2= [y1 L1*sind(theta1)+L2*sind(theta2)];

    LineXCood2= [x1 x1+x2];
    LineYCood2= [y1 y1+y2];
    
    line(LineXCood1,LineYCood1,'LineWidth',3)
    hold on
    line(LineXCood2,LineYCood2,'LineWidth',3)
    
    xlim([-2*L1 2*L1])
    ylim([-2*L1 2*L1])
    grid on
    pause(0.1)
    clf
 
    
    
end