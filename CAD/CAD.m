function CAD()
clc; home;
close all hidden

% Load grayscale image
% load('FracturesNoisy.mat', 'Img');
Img = imread('Shapes.png');
Img = double(Img(:, :, 1));
imshow(Img);



% Run edge detector
EdgeImg = Edges(Img);
Img = EdgeImg;
  
% For faster processing, resize to 50%
[nrows, ncols] = size(Img);
Img = Img(1:2:nrows, 1:2:ncols);
 
% Display what we have loaded
imshow(Img);
  
% Find lines
Enew = FindLine(Img);

% Done!
return;



