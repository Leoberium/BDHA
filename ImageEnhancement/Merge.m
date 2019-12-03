function X = Merge(L, D)
X = D;
sz = size(X);
for nr=1:sz(1)
    nr2 = floor((1+nr)/2);
    for nc=1:sz(2)
        nc2 = floor((1+nc)/2);
        X(nr, nc) = X(nr, nc) + L(nr2, nc2);
    end
end
imshow(X)
return