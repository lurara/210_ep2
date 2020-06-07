function teste_0 (p)
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
      
      %printf("resultado 1: %f\n", aux);
      b(x,y) = r(x,y) = aux;
      
      % [-1, 1]
      aux = (sin(y) + sin(x))/2;
      
      % Para que esteja entre 0 a 255, temos:
      aux = 255*aux;
      aux = aux + 255;
      aux =  aux/2;
      
      %printf("resultado 2: %f\n", aux);
      g(x,y) = aux;
      
    endfor
  endfor
  
  img = cat (3, r, g, b);
  %imshow (img);
  
  % Imagem RGB
  imwrite (img, 'teste_0.png', 'Quality', 100);
  
endfunction
