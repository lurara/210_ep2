% Função f descrita no EP
function f
  % número de pixels da imagem que queremos
  p = 1000;
  
  R = ones(p);
  G = ones(p);
  B = ones(p);
  
  for x = 1:1:p
    for y = 1:1:p
      R (x,y) = sin(x);
      G (x,y) = (sin(x) + sin(y))/2;
      B (x,y) = sin(x);
    endfor
  endfor
  
  img = cat (3, R, G, B);
  imshow (img);
  imwrite (img, 't1000.png', 'Quality', 100);
endfunction