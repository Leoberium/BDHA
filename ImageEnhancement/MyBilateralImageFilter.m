function MyBilateralImageFilter()
% Filtering images with averaging filter
clc; home;
close all hidden

% Load some image
Img = imread('Lenna.bmp');

% Display what we have loaded
imshow(Img);

% Find image sizes
[nrows, ncols] = size(Img);

% Create noisy version
Noisy = double(Img) + 60*rand(nrows, ncols);

% Make a copy (initialize filtered image)
FilteredImg = Noisy;

% Set filtering parameters
kI = 7500; lambda = .2; r = 6;

% Now, filter pixel by pixel
for nr = r+1:nrows-r-1 % for all image rows
    for nc = r+1:ncols-r-1 % for all image columns
        % Two loops for 2D pixel neighborhood
        sumV = 1; sumPV = Noisy(nr,nc);
        for neighbor_r = nr-r:nr+r
            for neighbor_c = nc-r:nc+r
                % distance between pixel locations
                dL = (neighbor_r-nr)^2 + (neighbor_c-nc)^2;
                if (dL < 1), continue, end % exclude self
                % distance between pixel intensities
                dI = (Noisy(nr, nc)-Noisy(neighbor_r, neighbor_c))^2;
                % weight
                w = lambda/( (1+dL)*exp(dI/kI) );
                % updating the sums
                sumV = sumV + w;
                sumPV = sumPV + w*Noisy(neighbor_r, neighbor_c);
            end
        end
        FilteredImg(nr, nc) = sumPV/sumV;
    end
end


% Display the origional, the noisy, and the filtered, side by side
imshow([Img Noisy FilteredImg], [0,250]);

% Done!
return