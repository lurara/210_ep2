function socorro
  p = 500;
  
  r = ones(p, 'uint8');
  g = ones(p, 'uint8');
  b = ones(p, 'uint8');
  
  for x = 1:p
    for y = 1:p
      
      r(x,y) = 500 - x;
      g(x,y) = 500 - y;
      b(x,y) = 1000 - x - y;
      
    endfor
  endfor
  
  img = cat (3, r, g, b);
  imshow (img);
  imwrite (img, 'socorro.png', 'Quality', 100);
endfunction
