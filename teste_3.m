% f(x,y) = (e^x/y ,  (x^y), ln (x+y) )

% preto_1: 255*sin(x/y)*sin(y/x)
% preto_2: 255*sin(x)*sin(y)
% novo_preto_3 : 255*sin(xy)
% preto_4: 255*sin(x)
function teste_3 (p)
  r = ones(p, 'uint8');
  g = ones(p, 'uint8');
  b = ones(p, 'uint8');
  
  for x = 1:p
    for y = 1:p
      % [-1, 1]
      aux = sin(x);
      
      % Para que esteja entre 0 a 255, temos:
      aux = 255*aux;
      aux = aux + 255;
      aux =  aux/2;
      
      r(x,y) = g(x,y) = b(x,y) = aux;
    endfor
  endfor
  
  img = cat (3, r, g, b);
  imshow (img);
  imwrite (img, 'Testoso.png', 'Quality', 100);
endfunction
