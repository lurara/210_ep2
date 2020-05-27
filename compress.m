% compress: comprime uma imagem mxn que torna-se pxp

function compress (originalImg, k)
  
  # Para receber o colormap exato da imagem:
  # uso o imread, recebendo o cmap e img
  [img, cmap] = imread(originalImg);
  
  # Tamanho da imagem
  [img_width, img_height] = size(img);
  
  #img_height # mostra valor de altura
  #img_width  # mostra valor de comprimento
  
  if(img_height != img_width)
   disp("A imagem inserida não é quadrada. Irei torná-la quadrada a partir do menor valor entre comprimento e largura.");
   
   if(img_height > img_width)
    img_p = img_width;
    img_height = img_width;
   else
    img_p = img_height;
    img_width = img_height;
   endif
   
  else
   disp("A imagem inserida é válida. Irei torná-la uma matriz.");
   img_p = img_height;
  endif
  
  n = floor ((img_p + k) / (k + 1)); % imagem comprimida será n x n
  
  printf("O valor gerado para n é %d.\n", n);
  
  new_img = eye (n); % imagem comprimida
  
  l = 1; % indica a linha na matriz original 
  c = 1; % indica a coluna
  
  % percorremos as linhas da nova imagem
  for i = 1:1:n
    % percorremos também as colunas dessa nova imagem    
    for j = 1:1:n
      
      new_img (i,j) = img(l,c);
      c += k+1; % avançamos para o próximo múltiplo de k+1
      
    endfor
    
    l += k+1; % avançamos para a próxima linha
    c = 1; % voltamos a coluna pro começo
    
  endfor
  
  #new_img # mostra valores da matriz, de 0 a 255
  imshow(new_img, cmap);
  #image(new_img);
  
  imwrite(new_img, cmap, 'new.png');
   
endfunction