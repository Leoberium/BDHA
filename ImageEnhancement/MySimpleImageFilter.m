function MySimpleImageFilter()
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

% Set filter radius
r = 5;

% Now, filter pixel by pixel
bCodingApproach = 0;
if (bCodingApproach == 0)
    for nr = r+1:nrows-r-1 % for all image rows
        for nc = r+1:ncols-r-1 % for all image columns
            % replacing pixel with the average
            FilteredImg(nr, nc) = mean2(Noisy(nr-r:nr+r, nc-r:nc+r));
        end
    end
else
    for nr = r+1:nrows-r-1
        for nc = r+1:ncols-r-1
            % Two loops for pixel neighborhood
            sumV = 0; sumPV = 0;
            for neighbor_r = nr-r:nr+r
                for neighbor_c = nc-r:nc+r
                    sumV = sumV+1;
                    sumPV = sumPV + Noisy(neighbor_r, neighbor_c);
                end
            end
            FilteredImg(nr, nc) = SumPV/SumV;
        end
    end
end

% Display the origional, the noisy, and the filtered, side by side
imshow([Img Noisy FilteredImg], [0,250]);

% Done!
return
                    


