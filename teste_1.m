% f(x,y) = (e^x/y ,  (x^y), ln (x+y) )

function teste_1 (p)
  r = ones(p, 'uint8');
 
  % max = 3*p*p + p 
  lim = 255/(3*p*p +p);
  
  for x = 1:p
    for y = 1:p
      
      r(x,y) = (3*y*y + x)*lim;
    endfor
  endfor
  
  %img = cat (3, r, g, b);
  imshow (r);
  imwrite (r, 'preto_new.png', 'Quality', 100);
endfunction 
