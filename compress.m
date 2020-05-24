% compress: comprime um imagem
% cupcake: largura = 754 ≃ 745 px
%          altura = 746 ≃ 745 px

function compress (originalImg, k)
  
  % lendo a imagem
  I = imread (originalImg, "PixelRegion", {[0 746],[0 746]});

  p = 745; % pixels da imagem do cupcake
  n = floor ((p + k) / (k + 1)) % imagem comprimida será n x n
  
  img = eye (n); % imagem comprimida
  
  l = 1; % indica a linha na matriz original 
  c = 1; % indica a coluna
  
  % percorremos as linhas da nova imagem
  for i = 1:1:n
    % percorremos também as colunas dessa nova imagem    
    for j = 1:1:n
      
      img (i,j) = I(l,c);
      c += k+1; % avançamos para o próximo múltiplo de k+1
      
    endfor
    
    l += k+1; % avançamos para a próxima linha
    c = 1; % voltamos a coluna pro começo
    
  endfor
  img
endfunction