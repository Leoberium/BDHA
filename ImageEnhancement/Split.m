function [L, D] = Split(X)
[nRows, nCols] = size(X);
L = zeros(floor(nRows/2), floor(nCols/2));
D = zeros(nRows, nCols);
for nr2=1:floor(nRows/2)
    nr = 2*nr2-1;
    for nc2=1:floor(nCols/2)
        nc = 2*nc2-1;
        avg = mean2(X(nr:nr+1,nc:nc+1));
        L(nr2, nc2) = avg;
        D(nr, nc) = X(nr, nc) - avg; D(nr+1, nc) = X(nr+1, nc) - avg;
        D(nr, nc+1) = X(nr, nc+1) - avg; D(nr+1, nc+1) = X(nr+1, nc+1) - avg;
    end
end
return;