% Function to find lines in the edge image EdgeImg
function E = FindLine(EdgeImg)

% Find image sizes
[nrows, ncols] = size(EdgeImg);

% Convert the image to 1D buffer, to compute quantiles
EdgeImg1D = reshape(EdgeImg, [nrows*ncols, 1]);
t = max(100, quantile(EdgeImg1D, 0.95)); % select edge intensity threshold

% Set min and max line sizes
r0 = 50; r1 = 2*r0;
nLine = 0;

% Search
tic
for x0 = 1:nrows
    progress = 100*x0/nrows % display current progress
    for y0 = 1:ncols
        if(EdgeImg(x0, y0) < t), continue; end % non-edge, skip
        
        for x1 = x0+1:min(x0+r1, nrows)
            for y1 = max(1, y0-r1):min(ncols, y0+r1)
                if(EdgeImg(x1, y1) < t), continue; end % non-edge, skip
                if(EdgeImg(round((x0+x1)/2), round((y0+y1)/2)) < t), continue; end
                
                d = sqrt( (x1-x0)^2 + (y1-y0)^2 );
                if d<r0 || d>r1
                    continue; % too  large or too small
                end
                
                a = (y0-y1)/(x0-x1);
                b = y0-a*x0;
                
                % Compute line cost function
                C = 0; dx = (x1-x0)/49;
                for x=x0:dx:x1
                    C = C + EdgeImg(round(x), round(a*x+b));
                end
                
                % Add new detected line
                nLine = nLine + 1;
                Lines(nLine, 1) = C; % save the cost of this line
                Lines(nLine, 2) = x0; Lines(nLine, 3) = y0; % save start point
                Lines(nLine, 4) = x1; Lines(nLine, 5) = y1; % save end point
                
            end
        end
    end
end
toc

% Sort detected lines by strength
Lines = sortrows(Lines, -1);
nLine = max(1, round(nLine/5));

% Draw the best lines
E = zeros(size(EdgeImg));
for nL=1:nLine
    x1 = Lines(nL,4); y1 = Lines(nL,5);
    x0 = Lines(nL,2); y0 = Lines(nL,3);
    a = (y1-y0)/(x1-x0);
    b = y0-a*x0;
    dx = (x1-x0)/r1; % Making enough steps here to make this line visible!
    for x=x0:dx:x1
        E(round(x), round(a*x+b))=255;
    end
end
imshow([EdgeImg E]);
return

                
                