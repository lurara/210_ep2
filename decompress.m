#decompress: descomprime uma imagem nxn

function decompress(compressedImg, method, k, h)
 
  # Para receber o colormap exato da imagem uso o imread, recebendo o cmap e img
  [img, cmap] = imread(compressedImg);
  
  # Tamanho da imagem
  [img_width, img_height, num] = size(img); 
  
  # Requisito para rodar esta função:
  if(img_width == img_height)
    n = img_height;
    
    # Novo número de pixels de linhas/colunas
    p = n + (n-1)*k;
    printf("O valor gerado para p é %d.\n", p);
    
    new_img = zeros(p, 'uint8');
    
    # Lógica análoga à do programa anterior
    # irei retirar o código abaixo, porque nçao vou usar
    l = c = 1;
    
    for i = 1:1:n
      for j = 1:1:n
        new_img (l,c) = img(i,j);
        c += k+1;
      endfor
      
      l += k+1;
      c = 1;
    endfor
    
    # Desta forma, a matriz resultante possui 0s como elementos nos k espaços 
    # entre as linhas e colunas originais.
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    # Interpolação por partes:
    
    switch(method)
      case 1 # Bilinear
        disp("Método 1: Interpolação bilinear ");
        # Criação das matrizes contendo valores das componentes RGB
        imshow(new_img); % isto será retirado dps
        
        # Conceder valor para eles nas respectivas posições
        RED = img(:,:,1);     # Red (n pixels)
        GREEN = img(:,:,2);   # Green (n pixels)
        BLUE = img(:,:,3);    # Blue (n pixels)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        new_R = zeros(p, 'uint8');
        
        l = c = 1;
        
        for i = 1:1:n
          for j = 1:1:n
            new_R (l,c) = img(i,j);
            c += k+1;
          endfor
          
          l += k+1;
          c = 1;
        endfor
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        new_G = zeros(p, 'uint8');
                
        l = c = 1;
        
        for i = 1:1:n
          for j = 1:1:n
            new_G (l,c) = img(i,j);
            c += k+1;
          endfor
          
          l += k+1;
          c = 1;
        endfor
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        new_B = zeros(p, 'uint8');
                
        l = c = 1;
        
        for i = 1:1:n
          for j = 1:1:n
            new_B (l,c) = img(i,j);
            c += k+1;
          endfor
          
          l += k+1;
          c = 1;
        endfor
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        # Primeiro vou iterar sobre a imagem original e, começando do elemento
        # (1,1), checo os "quadrados" de pixels mais próximos, ou seja, na primeira
        # iteração será (1,1), (1,2), (2,1) e (2,2). Preciso também checar se os
        # quadrados abaixo existem (ou seja, < n) e os do lado direito também.
        # Ao entrar em cada posição, preciso iterar sobre os pixels dentro desse
        # quadrado, ou seja, de (1,1) até (2+k, 2+k).
        
        # Para cada uma dessas iterações, o que vou fazer é interpolar para cada
        # conjunto de quadrados. Dessa forma, 
        
        q = 1;
        
        l = c = 1;
        
        coef = [1, 1, 1, 1];
        
        #iteração 1 por fora
        
        for i = 1:1:n       # existem k elementos entre cada um dos i
            # acho que so vai até n-1 se n != 1
            for j = 1:1:n   # existem k elementos entre cada um dos j
              # acho que so vai até n-1 se n != 1
              
              # A partir daqui vou iterar para cada quadrado
              # se for o primeiro, o método é diferente
              # mas nos outros oque vou fazer é interolar
              # para todos quadrados abaixo da primeira linha do quadrado
              # porque essa já vai ter sido interpolada anteriormente
              
              % OBS PRECISO CHECAR SE i+1 SE ENCONTRA NO INTERVALO
              coef(1) = RED( i, j );      # canto esquerdo superior
              coef(2) = RED( i, j+1 );    # canto direito superior 
              coef(3) = RED( i+1, j );    # canto esquerdo inferior
              coef(4) = RED( i+1, j+1 );  # canto direito inferior
              
              dist_x = h/(k+1);
              x = i;
              dist_y = h/(k+1);
              y = j;
              
              # INÍCIO DA INTERPOLAÇÃO PARA OS (K+2)x(K+2) ELEMENTOS
              for itr_i = i:1:i+k+1
                for itr_j = j:1:j+k+1
                  if(new_R(itr_i,itr_j) == 0 ) # só interpolo  valores que n est
                    %%%%INTERPOALAÇÃOOOOOOO%%%%%
                  endif
                  y += dist_y;
                endfor
               x += dist_x;
              endfor
              
              
              
            endfor
        endfor
        
        #(xi, yj ), tal que
        # xi = x + ih, x E R
        # yj = y + jh, y E R
        
        #(x, y) = (x0, y0) canto inferior esquerdo
        # (x+(p−1)h, y+(p−1)h) = (xp-1, yp-1) canto superior direito
        
        # Portanto, o h deve dividir o número de pixels total
        
        
      case 2 # Bicúbico
        disp("Método 2: Interpolação bicúbica ");
        # implementação
        
      otherwise # ??
        disp("Método inválido...");
        
    endswitch
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
  else
    disp("A imagem inserida não é quadrada. Por favor insira uma imagem nxn.");
    
  endif
  
endfunction