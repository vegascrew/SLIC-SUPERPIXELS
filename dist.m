function D = dist(C, im, r1, c1, S, m)
    [rs, cs, chan] = size(im);
    [x,y] = meshgrid(c1:(c1+cs-1), r1:(r1+rs-1));
    x = x-C(4); 
    y = y-C(5);
    ds2 = x.^2 + y.^2;
    
    for n = 1:3
        im(:,:,n) = (im(:,:,n)-C(n)).^2;
    end
    
    dc2 = sum(im,3);
    D = sqrt(dc2 + ds2/S^2 * m^2);
