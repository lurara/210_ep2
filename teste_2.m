% f(x,y) = (e^x/y ,  (x^y), ln (x+y) )

% preto_1: 255*sin(x/y)*sin(y/x)
% preto_2: 255*sin(x)*sin(y)
% novo_preto_3 : 255*sin(xy)
% preto_4: 255*sin(x)
function teste_2 (p)
  r = ones(p);
  g = ones(p);
  b = ones(p);
  
  for x = 1:p
    for y = 1:p
      
      r(x,y) = g(x,y) = b(x,y) = 255*sin(x/y)*sin(y/x);
    endfor
  endfor
  
  img = cat (3, r, g, b);
  imshow (img);
  imwrite (img, 'Testoso.png', 'Quality', 100);
endfunction
