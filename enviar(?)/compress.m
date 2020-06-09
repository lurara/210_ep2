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
  teto = false;
  
  # Condição para pegar a última linha e última coluna 
  if(n + (n - 1)*k < img_p) % SÓ VALE PARA RGB
    n++;  # n teto
    teto = true;
  endif
  
  printf("O valor gerado para n é %d.\n", n);
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  # Construção da nova imagem
  
  new_img = eye (n, 'uint8'); % nova imagem
  
  if(ehRGB == true)
  
    R = eye(n, 'uint8'); % componente RED
    G = eye(n, 'uint8'); % componente GREEN
    B = eye(n, 'uint8'); % componente BLUE
    
    # Preciso iterar para cada um dos RED, GREEN e BLUE
    
    #obs: se não gostar, é só tirar a condição abaixo:
    if( teto )
    
      for itr = 1:1:3
        if(itr == 1)
          aux = RED;
          new_aux = R;
        elseif(itr == 2)
          aux = GREEN;
          new_aux = G;
        else # itr == 3
          aux = BLUE;
          new_aux = B;
        endif
        
        l = c = 1;
        
        for i = 1:1:n-1
          for j = 1:1:n-1
            new_aux(i,j) = aux(l,c);
            c += k+1;
          endfor
          l += k+1;
          c = 1;
        endfor
        
        %%%%% última linha da matriz %%%%%
        
        l = c = 1;
        
        for i = 1:1:n-1
          new_aux (i,n) = aux(l,img_p);
          l += k+1;
        endfor
        
        for j = 1:1:n-1
          new_aux (n, j) = aux(img_p,c);
          c += k+1;
        endfor;
        
        new_aux (n,n) = aux (img_p, img_p);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        # Concatenando cores
        if(itr == 1)
          new_img = new_aux;
        else
          new_img = cat(3, new_img, new_aux);
        endif  
        
      endfor
          
      
    else # n floor
      
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
      
    endif    
    
    imshow(new_img);
    imwrite(new_img, 'compressed.png', 'Quality', 100);
       
  else  % NÃO RGB
    if(teto)   
      l = c = 1;
      
      for i = 1:1:n-1
        for j = 1:1:n-1
          new_img(i,j) = img(l,c);
          c += k+1;
        endfor
        l += k+1;
        c = 1;
      endfor
      
      %%%%% última linha da matriz %%%%%
      
      l = c = 1;
      
      for i = 1:1:n-1
        new_img (i,n) = img(l,img_p);
        l += k+1;
      endfor
      
      for j = 1:1:n-1
        new_img (n, j) = img(img_p,c);
        c += k+1;
      endfor;
      
      new_img (n,n) = img(img_p, img_p);
        
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
    
    if(iscolormap(cmap))
      imwrite(new_img, cmap, 'compressed.png', 'Quality', 100);
      imshow(new_img, cmap);
    else
      imwrite(new_img, 'compressed.png', 'Quality', 100);
      imshow(new_img);  
    endif
    
  endif
    
  #new_img # mostra valores da matriz, de 0 a 255
   
endfunction