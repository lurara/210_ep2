% f1 (x,y) = (255*sin(x/y) , 255*cos(x-y), 255*sin(x*y))
% f2 (x,y) = (sin (x²+y²), 200, y/x)
% f3 (x,y) = ( y / x, 500 /(x+y), ln (x/y) )

function coloridas 
  p = 500
  r = ones(p, 'uint8');
  g = ones(p, 'uint8');
  b = ones(p, 'uint8');
  
  for x = 1:p
    for y = 1:p
      
      
      
      
      %g(x,y) = (255-x-y);
      %r(x,y) = 255 - x + y;
      %b(x,y) = 500 - x - y;
      
      
    endfor
  endfor
  
  img = cat (3, r, g, b);
  imshow (img);
  imwrite (img, 'cor_1.png', 'Quality', 100);

endfunction