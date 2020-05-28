#decompress: descomprime uma imagem nxn

function decompress(compressedImg, method, k, h)
 
  # Para receber o colormap exato da imagem uso o imread, recebendo o cmap e img
  [img, cmap] = imread(compressedImg);
  
  # Tamanho da imagem
  [img_width, img_height, num] = size(img); 
  
  imshow(img);
  # Requisito para rodar esta função:
  if(img_width == img_height)
    n = img_height;
    
    # Novo número de pixels de linhas/colunas
    p = n + (n-1)*k;
    printf("O valor gerado para p é %d.\n", p);
    
    # Desta forma, a matriz resultante possui 0s como elementos nos k espaços 
    # entre as linhas e colunas originais.
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    # Interpolação por partes:
    
    switch(method)
      case 1 # Bilinear
        disp("Método 1: Interpolação bilinear ");
        # Criação das matrizes contendo valores das componentes RGB
        #imshow(new_img); % isto será retirado dps
        
        # Conceder valor para eles nas respectivas posições
        RED = img(:,:,1);     # Red (n pixels)
        GREEN = img(:,:,2);   # Green (n pixels)
        BLUE = img(:,:,3);    # Blue (n pixels)
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        new_R = zeros(p, 'uint8');
        
        l = c = 1;
        
        for i = 1:1:n
          for j = 1:1:n
            new_R (l,c) = RED(i,j);
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
            new_G (l,c) = GREEN(i,j);
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
            new_B (l,c) = BLUE(i,j);
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
        
        l = c = 1;
        
        coef = [-1, 1, 1, 1];
        
        for i = 1:1:n-1       # existem k elementos entre cada um dos i
            # acho que so vai até n-1 se n != 1
            for j = 1:1:n-1   # existem k elementos entre cada um dos j
              # acho que so vai até n-1 se n != 1
              
              # A partir daqui vou iterar para cada quadrado
              # se for o primeiro, o método é diferente
              # mas nos outros oque vou fazer é interolar
              # para todos quadrados abaixo da primeira linha do quadrado
              # porque essa já vai ter sido interpolada anteriormente
              
              % OBS PRECISO CHECAR SE i+1 SE ENCONTRA NO INTERVALO
              coef(1) = double (RED(i, j));                    # canto esquerdo superior
              # a0 = f(xi,yj)
              coef(2) = (double (RED( i, j+1 )) - coef(1));                  # canto direito superior 
              # a0 + a1h = f(xi, yj+1)
              # a1h = f(xi,yj+1) - a0
              coef(3) = (double (RED( i+1, j )) - coef(1));                 # canto esquerdo inferior
              # a0 + a2h = f(xi+1,yj)
              # a2h = f(xi+1,yj) - a0
              coef(4) = (double (RED(i+1,j+1)) - coef(1) - coef(2) - coef(3))/(h*h);                # canto direito inferior
              # a0 + a1h + a2h + a3h^2 = f(xi+1,yi+1)
              # a3h² = f(xi+1,yi+1) - ao - a1h - a2h
              # a3   = (f(xi+1,yi+1) - ao - a1h - a2h)/h²
              
              # Acertando valor
              coef(2) /= h;
              coef(3) /= h;
              
              dist_x = h/(k+1);
              x = i*h;
              dist_y = h/(k+1);
              y = j*h;
              
              #input("ENTER")
              # 1 + 0k = 1
              # 2 +1k = 5
              # 3 +2k = 9
              # 4 +3k = 13
              
              itr_i = i + (i-1)*k;
              itr_j = j + (j-1)*k;
              
              # INÍCIO DA INTERPOLAÇÃO PARA OS (K+2)x(K+2) ELEMENTOS
              #for itr_i = i:1:i+k+1
              for itr_i = (i + (i-1)*k):1:(i + (i-1)*k)+k+1
                #for itr_j = j:1:j+k+1
                 for itr_j = (j + (j-1)*k):1:(j + (j-1)*k)+k+1
                  if(new_R(itr_i,itr_j) == 0 ) # só interpolo  valores que n estão >>>>>>>>>> PRECISO MUDAR PROVAVEL MAS ATÉ AHR FUNCIONA
                    #printf("(%d,%d): ", itr_i, itr_j);
                    %%%%INTERPOALAÇÃOOOOOOO%%%%%
                    new_R(itr_i,itr_j) = coef(1) + coef(3)*(x-i*h)+ coef(2)*(y-j*h) + coef(4)*(x-i*h)*(y-j*h);
                    #f(x, y) ≈ pij (x, y) = a0 + a1(x − xi) + a2(y − yj ) + a3(x − xi)(y − yj )
                    #printf(" %d ", new_R(itr_i,itr_j));
                  endif
                  y += dist_y;
                endfor
               x += dist_x;
               #disp("\n");
               y = j*h;
              endfor
              
              #disp("\n");
              #n++;
            endfor
        endfor
        
        #new_R
        # GREEN
        l = c = 1;
        
        coef = [-1, 1, 1, 1];
        
        for i = 1:1:n-1
            for j = 1:1:n-1
              
              coef(1) = double (GREEN(i, j));
              coef(2) = (double (GREEN( i, j+1 )) - coef(1));
              coef(3) = (double (GREEN( i+1, j )) - coef(1));
              coef(4) = (double (GREEN(i+1,j+1)) - coef(1) - coef(2) - coef(3))/(h*h);
              
              coef(2) /= h;
              coef(3) /= h;
              
              dist_x = h/(k+1);
              x = i*h;
              dist_y = h/(k+1);
              y = j*h;
              
              itr_i = i + (i-1)*k;
              itr_j = j + (j-1)*k;
              
              for itr_i = (i + (i-1)*k):1:(i + (i-1)*k)+k+1
                 for itr_j = (j + (j-1)*k):1:(j + (j-1)*k)+k+1
                  if(new_G(itr_i,itr_j) == 0 )
                    new_G(itr_i,itr_j) = coef(1) + coef(3)*(x-i*h)+ coef(2)*(y-j*h) + coef(4)*(x-i*h)*(y-j*h);
                  endif
                  y += dist_y;
                  
                endfor
               x += dist_x;
               y = j*h;
               
              endfor
            endfor
        endfor
        
        # BLUE
        l = c = 1;
        
        coef = [-1, 1, 1, 1];
        
        for i = 1:1:n-1
            for j = 1:1:n-1
              
              coef(1) = double (BLUE(i, j));
              coef(2) = (double (BLUE( i, j+1 )) - coef(1));
              coef(3) = (double (BLUE( i+1, j )) - coef(1));
              coef(4) = (double (BLUE(i+1,j+1)) - coef(1) - coef(2) - coef(3))/(h*h);
              
              coef(2) /= h;
              coef(3) /= h;
              
              dist_x = h/(k+1);
              x = i*h;
              dist_y = h/(k+1);
              y = j*h;
              
              itr_i = i + (i-1)*k;
              itr_j = j + (j-1)*k;
              
              for itr_i = (i + (i-1)*k):1:(i + (i-1)*k)+k+1
                 for itr_j = (j + (j-1)*k):1:(j + (j-1)*k)+k+1
                  if(new_B(itr_i,itr_j) == 0 )
                    new_B(itr_i,itr_j) = coef(1) + coef(3)*(x-i*h)+ coef(2)*(y-j*h) + coef(4)*(x-i*h)*(y-j*h);
                  endif
                  y += dist_y;
                  
                endfor
               x += dist_x;
               y = j*h;
               
              endfor
            endfor
        endfor
        
        #new_R
        #imshow(new_B);
        
        # Concantenação das matrizes de cores, formando a imagem final
        new_img = cat(3,new_R,new_G,new_B);
        
        imshow(new_img);               % mostrando imagem RGB
        imwrite(new_img, 'expand.png');   % salvando imagem RGB
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