% Demo to use the radon transform to determine the angle to rotate an image to straighten it.
% Initialization / clean-up code.
clc;    % Clear the command window.
close all;  % Close all figures (except those of imtool.)
clear;  % Erase all existing variables. Or clearvars if you want.
workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;

% Read in the color demo image.
[rgbImage, colorMap] = imread('football.jpg');
subplot(2, 3, 1);
imshow(rgbImage, colorMap);
axis on;
title('Original Color Image', 'FontSize', fontSize);
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Extract the red channel and display it.
grayImage = rgbImage(:, :, 1);
subplot(2, 3, 2);
imshow(grayImage, colorMap);
axis on;
title('Red Channel Image', 'FontSize', fontSize);

% Do the Radon transform.
theta = 0:180;
[R,xp] = radon(grayImage,theta);
% Find the location of the peak of the radon transform image.
maxR = max(R(:));
[rowOfMax, columnOfMax] = find(R == maxR);
% Display the Radon Transform image.
h3 = subplot(2, 3, [3,6]);
imshow(R,[],'Xdata',theta,'Ydata',xp,...
            'InitialMagnification','fit')
axis on;
% Plot a blue circle over the max.
hold on;
plot(h3, columnOfMax, xp(rowOfMax), 'bo', 'MarkerSize', 30, 'LineWidth', 3);
line([columnOfMax, columnOfMax], [xp(end), xp(rowOfMax)+15], 'Color', 'b', 'LineWidth', 3);
caption = sprintf('Radon Transform.  Max at angle %.1f', columnOfMax);
title(caption, 'FontSize', fontSize);
xlabel('\theta (degrees)', 'FontSize', fontSize)
ylabel('x''', 'FontSize', fontSize)
colormap(h3, hot(256));
colorbar;

% The column of the max is the angle of the football --
% the angle that the projected sum (profile) will have the highest sum.
% Rotate it by minus that angle to straighten it.
rotatedImage = imrotate(rgbImage, -columnOfMax);
% Display the rotated image.
subplot(2, 3, 4);
imshow(rotatedImage);
axis on;
title('Rotated Color Image', 'FontSize', fontSize);
% Rotate perpendicular to that angle and display that rotation.
rotatedImage = imrotate(rgbImage, -columnOfMax+90);
subplot(2, 3, 5);
imshow(rotatedImage);
axis on;
title('Rotated Color Image', 'FontSize', fontSize);