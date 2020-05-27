% compress: comprime uma imagem mxn que torna-se pxp

function compress2 (originalImg, k)
  
  # Para receber o colormap exato da imagem:
  # uso o imread, recebendo o cmap e img
  [img, cmap] = imread(originalImg);
  #imfinfo(originalImg)
  
  # Tamanho da imagem
  [img_width, img_height, num] = size(img);
  
  
  # O tratamento de imagens RGB é
  # diferente do tratamento para
  # imagens que não o são.
  if( num == 3)
    disp("A imagem é RGB!");
    RED = img(:,:,1); # Red
    GREEN = img(:,:,2); # Green
    BLUE = img(:,:,3); # Blue
    
    ehRGB = true;
    
  else
    disp("A imagem não é RGB!");
    ehRGB = false;
  endif
  
  # Setando o colormap para RGB!
  numberOfRows = 256; 
  myColorMap = jet(numberOfRows);
  
  img_height # mostra valor de altura
  img_width  # mostra valor de comprimento
  
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
  
  new_img = eye (n, 'uint8'); % imagem comprimida
  
    if(ehRGB == true)
    R = eye(n, 'uint8');
    G = eye(n, 'uint8');
    B = eye(n, 'uint8');
    
    # Preciso iterar para cada um dos RED, GREEN e BLUE
    l = 1; % indica a linha na matriz original 
    c = 1; % indica a coluna
    
    % percorremos as linhas da nova imagem
    for i = 1:1:n
      % percorremos também as colunas dessa nova imagem    
      for j = 1:1:n
        
        R (i,j) = RED(l,c);
        c += k+1; % avançamos para o próximo múltiplo de k+1
        
      endfor
      
      l += k+1; % avançamos para a próxima linha
      c = 1; % voltamos a coluna pro começo
    endfor
    
    # Preciso iterar para cada um dos RED, GREEN e BLUE
    l = 1; % indica a linha na matriz original 
    c = 1; % indica a coluna
    
    % percorremos as linhas da nova imagem
    for i = 1:1:n
      % percorremos também as colunas dessa nova imagem    
      for j = 1:1:n
        
        G (i,j) = GREEN(l,c);
        c += k+1; % avançamos para o próximo múltiplo de k+1
        
      endfor
      
      l += k+1; % avançamos para a próxima linha
      c = 1; % voltamos a coluna pro começo
      endfor
        # Preciso iterar para cada um dos RED, GREEN e BLUE
    l = 1; % indica a linha na matriz original 
    c = 1; % indica a coluna
    
    % percorremos as linhas da nova imagem
    for i = 1:1:n
      % percorremos também as colunas dessa nova imagem    
      for j = 1:1:n
        
        B (i,j) = BLUE(l,c);
        c += k+1; % avançamos para o próximo múltiplo de k+1
        
      endfor
      
      l += k+1; % avançamos para a próxima linha
      c = 1; % voltamos a coluna pro começo
      endfor
    
    new_img = cat(3,R,G,B);
    
    
    else
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
  endif
    
  #iscolormap(cmap)
  #new_img # mostra valores da matriz, de 0 a 255
  imshow(new_img, myColorMap);
  imwrite(new_img, 'new.png'); 
   
endfunction