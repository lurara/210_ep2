% f1 (x,y) = (255*sin(x/y) , 255*cos(x-y), 255*sin(x*y))
% f2 (x,y) = (sin (x²+y²), 200, y/x)

function coloridas 
  p = 500
  r = ones(p, 'uint8');
  g = ones(p, 'uint8');
  b = ones(p, 'uint8');
  
  for x = 1:p
    for y = 1:p
      % [-1,1]
      aux = sin(x*x+y*y);
      
      % Para que esteja entre 0 a 255, temos:
      aux = 255*aux;
      aux = aux + 255;
      aux =  aux/2;
      
      r(x,y) = aux;
      
      b(x,y) = 200;
      
      %[0.00000..., 1] imagem quadrada
      aux = y/x;
      
      % Para que esteja entre 0 a 255, temos:
      aux = 255*aux;
      
      g(x,y) = aux;
      
    endfor
  endfor
  
  img = cat (3, r, g, b);
  imshow (img);
  imwrite (img, 'cor_2.png', 'Quality', 100);

endfunction