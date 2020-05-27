% compress: comprime uma imagem mxn que torna-se pxp

function compress (originalImg, k)
  
  # Para receber o colormap exato da imagem uso o imread, recebendo o cmap e img
  [img, cmap] = imread(originalImg);
  #imfinfo(originalImg)
  
  # Tamanho da imagem ('num' representa a dimensão da imagem)
  [img_width, img_height, num] = size(img);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # O tratamento de imagens RGB é diferente do tratamento para imagens que não o são:
  
  if( num == 3) # RGB
    disp("A imagem é RGB!");
    
    # Criação das matrizes contendo valores das componentes RGB
    RED = img(:,:,1);     # Red
    GREEN = img(:,:,2);   # Green
    BLUE = img(:,:,3);    # Blue
    
    ehRGB = true;
    
  else  # NÃO RGB
    disp("A imagem não é RGB!");        
    ehRGB = false;
    
  endif
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Checagem do comprimento e da altura da imagem
  
  img_height # mostra valor de altura
  img_width  # mostra valor de comprimento
  
  # Como eu preciso supor que a imagem é quadrada, tenho que aceitar mesmo as
  # imagens que não o são. Talvez eu só as aceite direto na próxima;;
  if(img_height != img_width)
   ans = input("A imagem inserida não é válida. (ENTER) ");
   
   disp("Irei torná-la quadrada a partir do menor valor entre os eixos.");
   
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
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Construção da nova imagem
  
  new_img = eye (n, 'uint8'); % nova imagem
  
  if(ehRGB == true)
  
    R = eye(n, 'uint8'); % componente RED
    G = eye(n, 'uint8'); % componente GREEN
    B = eye(n, 'uint8'); % componente BLUE
    
    # Preciso iterar para cada um dos RED, GREEN e BLUE

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% RED %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    l = c = 1;
    
    for i = 1:1:n   
      for j = 1:1:n
        R (i,j) = RED(l,c);
        c += k+1;
      endfor
      l += k+1;
      c = 1;
    endfor
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% GREEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    
    l = c = 1;
  
    for i = 1:1:n
      for j = 1:1:n
        G (i,j) = GREEN(l,c);
        c += k+1;
      endfor
      l += k+1; 
      c = 1; 
    endfor
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BLUE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    l = c = 1;
    
    for i = 1:1:n
      for j = 1:1:n
        B (i,j) = BLUE(l,c);
        c += k+1;
      endfor
      l += k+1;
      c = 1;
    endfor
    
    # Concantenação das matrizes de cores, formando a imagem final
    new_img = cat(3,R,G,B);
    
    imshow(new_img);               % mostrando imagem RGB
    imwrite(new_img, 'new.png');   % salvando imagem RGB
       
  else  % NÃO RGB
       
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
    
    imwrite(new_img, cmap, 'new.png'); % salvando imagem não RGB
    imshow(new_img, cmap);
  endif
    
  #new_img # mostra valores da matriz, de 0 a 255
   
endfunction