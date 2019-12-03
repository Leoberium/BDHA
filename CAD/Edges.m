% Simple edge detector
function Edges = Edges(Img)

% Find image size
[nrows, ncols] = size(Img);

% Initialize edge image to zero
Edges = zeros(size(Img));

% Compute edge strength (as gradient) at each pixel
for x=2:nrows-1
    for y=2:ncols-1
        Edges(x, y) = sqrt((Img(x+1, y)-Img(x-1,y))^2 + ...
            (Img(x,y+1)-Img(x,y-1))^2);
    end
end

% Display the original image and its edges, size by side
imshow([Img Edges]);

return