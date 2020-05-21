% compress: comprime um imagem
% cupcake: largura = 754 ≃ 745 px
%          altura = 746 ≃ 745 px

function compress (originalImg, k)
  
  % lendo a imagem
  I = imread (originalImg, "PixelRegion", {[0 746],[0 746]});

  p = 745; % pixels da imagem do cupcake
  n = floor ((p + k) / (k + 1)); % imagem comprimida será n x n
  
  img = eye (n); % imagem comprimida

  for i = 1:1:n+1
    if mod (i-1,k+1) == 0
      for j = 1:1:n+1
        if mod (j-1,k+1) == 0
          img((i-1)/(k+1) + 1,(j-1)/(k+1) + 1) = I(i,j);
        endif
      endfor
    endif
  endfor
  img
endfunction