function [l,d] = Harshitslic(im, k, wt, med_win, itr)
    %fprintf('%d %d %d %d %d',k,wt,sr,med_win,itr);
    [rs, cs, chan] = size(im);
    im = rgb2lab(im); 
    
    if med_win
        if length(med_win) == 1
            med_win(2) = med_win(1);  
        end
        for n = 1:3
            im(:,:,n) = medfilt2(im(:,:,n), [med_win(1) med_win(2)]);
        end
    end
   
    S = sqrt(rs*cs / k);
    ncs = round(cs/S);
    nrs = round(rs/S);
    vs = rs/nrs;

    k = nrs * ncs;
    C = zeros(6,k);         
    l = -ones(rs, cs);  
    d = inf(rs, cs);     
    kk = 1;
    r = vs/2;
    
    for xx = 1:nrs
        if mod(xx,2) 
            c = S/2; 
        else
            c = S; 
        end
        
        for yy = 1:ncs
            cc = round(c); rr = round(r);
            C(1:5, kk) = [squeeze(im(rr,cc,:)); cc; rr];
            c = c+S;
            kk = kk+1;
        end
        
        r = r+vs;
    end

    S = round(S);  
    
    for n = 1:itr
       for kk = 1:k  
           xmin = max(C(5,kk)-S, 1);   xmax = min(C(5,kk)+S, rs);
           ymin = max(C(4,kk)-S, 1);   ymax = min(C(4,kk)+S, cs);
           si = im(xmin:xmax, ymin:ymax, :); 
           D = dist(C(:, kk), si, xmin, ymin, S, wt);
           sd =  d(xmin:xmax, ymin:ymax);
           sl =  l(xmin:xmax, ymin:ymax);
           mask = D < sd;
           sd(mask) = D(mask);
           sl(mask) = kk;
           d(xmin:xmax, ymin:ymax) = sd;
           l(xmin:xmax, ymin:ymax) = sl;           
       end
       
       C(:) = 0;
       for r = 1:rs
           for c = 1:cs
              tmp = [im(r,c,1); im(r,c,2); im(r,c,3); c; r; 1];
              C(:, l(r,c)) = C(:, l(r,c)) + tmp;
           end
       end
       
       for kk = 1:k 
           C(1:5,kk) = round(C(1:5,kk)/C(6,kk)); 
       end
    end
