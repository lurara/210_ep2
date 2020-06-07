% f(x,y) = (e^x/y ,  (x^y), ln (x+y) )

function teste_1 (p)
  r = ones(p);
  g = ones(p);
  b = ones(p);
  
  for x = 1:p
    for y = 1:p
      
      r(x,y) = g(x,y) = b(x,y) = 255*sin(y*y-x*x);
    endfor
  endfor
  
  img = cat (3, r, g, b);
  imshow (img);
  
  img
endfunction
