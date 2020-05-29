#decompress: descomprime uma imagem nxn

function decompress(compressedImg, method, k, h)
 
  # Para receber o colormap exato da imagem uso o imread, recebendo o cmap e img
  [img, cmap] = imread(compressedImg);
  
  # Tamanho da imagem
  [img_width, img_height, dim] = size(img); 
  
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
    
    switch(method)
      case 1 # Bilinear
        disp("Método 1: Interpolação bilinear ");
        # Criação das matrizes contendo valores das componentes RGB
        #imshow(new_img); % isto será retirado dps
        
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
          for j = 1:1:n-1   # existem k elementos entre cada um dos j
            
            # A partir daqui vou iterar para cada quadrado
            # se for o primeiro, o método é diferente
            # mas nos outros oque vou fazer é interolar
            # para todos quadrados abaixo da primeira linha do quadrado
            # porque essa já vai ter sido interpolada anteriormente
            
            % OBS PRECISO CHECAR SE i+1 SE ENCONTRA NO INTERVALO
            coef(1) = double (RED(i, j));
            coef(2) = (double (RED( i, j+1 )) - coef(1));
            coef(3) = (double (RED( i+1, j )) - coef(1));
            coef(4) = (double (RED(i+1,j+1)) - coef(1) - coef(2) - coef(3))/(h*h);
            
            # Acertando valor
            coef(2) /= h;
            coef(3) /= h;
            
            # Cálculo da posição nos Reais
            dist_x = h/(k+1);
            x = i*h;
            dist_y = h/(k+1);
            y = j*h;
            
            # Equivalência de posição
            itr_i = i + (i-1)*k;
            itr_j = j + (j-1)*k;
            
            # INÍCIO DA INTERPOLAÇÃO PARA OS (K+2)x(K+2) ELEMENTOS
            for itr_i = (i + (i-1)*k):1:(i + (i-1)*k)+k+1
              for itr_j = (j + (j-1)*k):1:(j + (j-1)*k)+k+1
              
                if(new_R(itr_i,itr_j) == 0 )
                  new_R(itr_i,itr_j) = coef(1) + coef(3)*(x-i*h) + coef(2)*(y-j*h) + coef(4)*(x-i*h)*(y-j*h);
                endif                
                y += dist_y;
                
              endfor
              x += dist_x;
              y = j*h;
            endfor
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
        
        # Concantenação das matrizes de cores, formando a imagem final
        new_img = cat(3,new_R,new_G,new_B);
        
        imshow(new_img);                        % mostrando imagem RGB
        imwrite(new_img, 'decompressed.png');   % salvando imagem RGB     
        
      case 2 # Bicúbico
        disp("Método 2: Interpolação bicúbica ");
        # implementação
        
        
        # As matrizes abaixo serão usadas para calcular os coeficientes.
        B = [ 1, 0, 0, 0; 1, h, h*h, h*h*h; 0, 1, 0, 0; 0, 1, 2*h*h, 3*h*h ];
        BT = B';
        BI = inv(B);
        BTI = inv(BT);
        
        # Para cada uma dessas iterações, o que vou fazer é interpolar para cada
        # conjunto de quadrados. Dessa forma, 
        
        l = c = 1;
        
        coef = [-1, 1, 1, 1];
        
        
        
        for i = 1:1:n-1       # existem k elementos entre cada um dos i
            for j = 1:1:n-1   # existem k elementos entre cada um dos j
              
              # "Coeficientes" da matriz
              # (a22) derivada parcial de y de (i-1,j) 
              if(i == 1)
                delij = 0; # ??? sla
              elseif( j == 1)
                delij = (double (RED(i-1, j+1)) - double (RED(i-1,j)))/h;
              else
                delij = (double (RED(i-1, j+1)) - double(RED(i-1, j-1)))/(2*h);
              endif
              
              # (a23) derivada parcial de y de (i-1, j+1)
              if(i == 1)
                deliJ = 0;
              elseif(j == n-1)
                deliJ = (double(RED(i-1,j+1)) - double(RED(i-1, j)))/h;
              else
                deliJ = (double(RED(i-1, j+2)) - double(RED(i-1, j)))/(2*h);
              endif
              
              # (a32) derivada parcial de y de (i+2, j)
              if(i == n-1)
                delIj = 0;
              elseif(j == 1)
                delIj = (double(RED(i+2, j+1)) - double(RED(i+2, j)))/h;
              else
                delIj = (double(RED(i+2, j+1)) - double(RED(i+2, j-1)))/(2*h);
              endif
              
              # (a33) derivada parcial de y de (i+2, j+1)
              if(i == n-1)
                delIJ = 0;
              elseif(j == n-1)
                delIJ = (double (RED(i+2, j+1)) - double(RED(i+2, j)))/h;
              else
                delIJ = (double (RED(i+2, j+2)) - double(RED(i+2, j)))/(2*h);
              endif
            
              % OBS CASOS ESPECIAIS SÃO AS BORDAS!! CHECAR AS BORDAS!!!
              
              a00 = double (RED(i,j));
              a01 = double (RED(i, j+1));
              
              if(j == 1) # ok
                a02 = (double (RED(i, j+1)) - double(RED(i,j)))/h;
              else
                a02 = (double (RED(i, j+1)) - double(RED(i, j-1)))/(2*h);
              endif
              
              if(j == n-1) # ok
                a03 = (double(RED(i, j+1)) - double(RED(i, j)))/h;
              else
                a03 = (double(RED(i, j+2)) - double(RED(i, j)))/(2*h);
              endif
              
              a10 = double (RED(i+1, j));
              a11 = double (RED(i+1, j+1));
              
              if(j == 1) # ok
                a12 = (double (RED(i+1, j+1)) - double (RED(i+1,j)))/h;
              else
                a12 = (double (RED(i+1, j+1)) - double(RED(i+1, j-1)))/(2*h);
              endif
              
              if(j == n-1) # ok
                a13 = (double(RED(i+1, j+1)) - double(RED(i+1, j)))/h;
              else
                a13 = (double(RED(i+1, j+2)) - double(RED(i+1, j)))/(2*h);
              endif
              
              if(i == 1)  # ok
                a20 = (double (RED(i+1, j)) - double (RED(i, j)))/(h);
              else
                a20 = ( double (RED(i+1, j)) - double (RED(i-1, j)))/(2*h);
              endif
              
              if(i == 1) # ok
                a21 = (double (RED(i+1, j+1)) - double (RED(i, j+1)))/(h);
              else
                a21 = (double (RED(i+1, j+1)) - double (RED(i-1, j+1)))/(2*h);
              endif
              
              a22 = (a12 - delij)/(2*h);
              a23 = (a13 - deliJ)/(2*h);
              
              if(i == n-1) # ok
                a30 = (double (RED(i+1, j)) - double (RED(i, j)))/(h);
              else
                a30 = (double (RED(i+2, j)) - double(RED(i, j)))/(2*h);
              endif
            
              if(i == n-1) # ok
                a31 = (double (RED(i+1, j+1)) - double (RED(i, j+1)))/(h);
              else
                a31 = (double (RED(i+2, j+1)) - double (RED(i, j+1)))/(2*h);
              endif
              
              a32 = (delIj - a02)/(2*h);
              a33 = (delIJ - a03)/(2*h);
              
              COEF = [ a00, a01, a02, a03;
                       a10, a11, a12, a13;
                       a20, a21, a22, a23;
                       a30, a31, a32, a33 ];
                       
              COEF = BI*COEF;
              COEF = COEF*BTI;
              
              dist_x = h/(k+1);
              x = i*h;
              dist_y = h/(k+1);
              y = j*h;
              
              var_x = [ 1, 1, 1, 1 ];
              var_y = [ 1; 1; 1; 1 ];
              
              itr_i = i + (i-1)*k; # itr_i é o equivalente da posição i calculada na nova matriz
              itr_j = j + (j-1)*k; # itr_j é o equivalente da posição j calculada na nova matriz
              
              # INÍCIO DA INTERPOLAÇÃO PARA OS (K+2)x(K+2) ELEMENTOS
              for itr_i = (i + (i-1)*k):1:(i + (i-1)*k)+k+1
                 for itr_j = (j + (j-1)*k):1:(j + (j-1)*k)+k+1
                  if(new_R(itr_i,itr_j) == 0 )
                    var_x = [1, (x - i*h), (x-i*h)^2, (x-i*h)^3];
                    var_y = [1; (y - j*h); (y-j*h)^2; (y-j*h)^3];
                    aux = var_x *COEF;
                    new_R(itr_i, itr_j) = aux * var_y;
                  endif
                  y += dist_y;
                 endfor
                x += dist_x;
                y = j*h;
              endfor
            endfor
        endfor

        #imshow(new_R);
        imwrite(new_R, 'luffyr.png');
        input("ENTER");
        
        # BLUEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE
        l = c = 1;
        
        for i = 1:1:n-1
            for j = 1:1:n-1
              
              if(i == 1)
                delij = 0; # ??? sla
              elseif( j == 1)
                delij = (double (BLUE(i-1, j+1)) - double (BLUE(i-1,j)))/h;
              else
                delij = (double (BLUE(i-1, j+1)) - double(BLUE(i-1, j-1)))/(2*h);
              endif
              
              
              # (a23) derivada parcial de y de (i-1, j+1)
              if(i == 1)
                deliJ = 0;
              elseif(j == n-1)
                deliJ = (double(BLUE(i-1,j)) - double(BLUE(i-1, j-1)))/h;
              else
                deliJ = (double(BLUE(i-1, j+2)) - double(BLUE(i-1, j)))/(2*h);
              endif
              
              # (a32) derivada parcial de y de (i+2, j)
              if(i == n-1)
                delIj = 0;
              elseif(j == 1)
                delIj = (double(BLUE(i+2, j+1)) - double(BLUE(i+2, j)))/h;
              else
                delIj = (double(BLUE(i+2, j+1)) - double(BLUE(i+2, j-1)))/(2*h);
              endif
              
              # (a33) derivada parcial de y de (i+2, j+1)
              if(i == n-1)
                delIJ = 0;
              elseif(j == n-1)
                delIJ = (double (BLUE(i+2, j)) - double(BLUE(i+2, j-1)))/h;
              else
                delIJ = (double (BLUE(i+2, j+2)) - double(BLUE(i+2, j)))/(2*h);
              endif
            
              % OBS CASOS ESPECIAIS SÃO AS BORDAS!! CHECAR AS BORDAS!!!
              
              a00 = double (BLUE(i,j));
              a01 = double (BLUE(i, j+1));
              
              if(j == 1) # ok
                a02 = (double (BLUE(i, j+1)) - double(BLUE(i,j)))/h;
              else
                a02 = (double (BLUE(i, j+1)) - double(BLUE(i, j-1)))/(2*h);
              endif
              
              if(j == n-1) # ok
                a03 = (double(BLUE(i, j)) - double(BLUE(i, j-1)))/h;
              else
                a03 = (double(BLUE(i, j+2)) - double(BLUE(i, j)))/(2*h);
              endif
              
              a10 = double (BLUE(i+1, j));
              a11 = double (BLUE(i+1, j+1));
              
              if(j == 1) # ok
                a12 = (double (BLUE(i+1, j+1)) - double (BLUE(i+1,j)))/h;
              else
                a12 = (double (BLUE(i+1, j+1)) - double(BLUE(i+1, j-1)))/(2*h);
              endif
              
              if(j == n-1) # ok
                a13 = (double(BLUE(i+1, j)) - double(BLUE(i+1, j-1)))/h;
              else
                a13 = (double(BLUE(i+1, j+2)) - double(BLUE(i+1, j)))/(2*h);
              endif
              
              if(i == 1)  # ok
                a20 = (double (BLUE(i+1, j)) - double (BLUE(i, j)))/(h);
              else
                a20 = ( double (BLUE(i+1, j)) - double (BLUE(i-1, j)))/(2*h);
              endif
              
              if(i == 1) # ok
                a21 = (double (BLUE(i+1, j+1)) - double (BLUE(i, j+1)))/(h);
              else
                a21 = (double (BLUE(i+1, j+1)) - double (BLUE(i-1, j+1)))/(2*h);
              endif
              
              a22 = (a12 - delij)/(2*h);
              a23 = (a13 - deliJ)/(2*h);
              
              if(i == n-1) # ok
                a30 = (double (BLUE(i, j)) - double (BLUE(i-1, j)))/(h);
              else
                a30 = (double (BLUE(i+2, j)) - double(BLUE(i, j)))/(2*h);
              endif
            
              if(i == n-1) # ok
                a31 = (double (BLUE(i, j+1)) - double (BLUE(i-1, j+1)))/(h);
              else
                a31 = (double (BLUE(i+2, j+1)) - double (BLUE(i, j+1)))/(2*h);
              endif
              
              a32 = (delIj - a02)/(2*h);
              a33 = (delIJ - a03)/(2*h);
              
              COEF = [ a00, a01, a02, a03;
                       a10, a11, a12, a13;
                       a20, a21, a22, a23;
                       a30, a31, a32, a33 ];
                       
              COEF = BI*COEF;
              COEF = COEF*BTI;
              
              dist_x = h/(k+1);
              x = i*h;
              dist_y = h/(k+1);
              y = j*h;
              
              var_x = [ 1, 1, 1, 1 ];
              var_y = [ 1; 1; 1; 1 ];
              
              itr_i = i + (i-1)*k; # itr_i é o equivalente da posição i calculada na nova matriz
              itr_j = j + (j-1)*k; # itr_j é o equivalente da posição j calculada na nova matriz
              
              # INÍCIO DA INTERPOLAÇÃO PARA OS (K+2)x(K+2) ELEMENTOS
              for itr_i = (i + (i-1)*k):1:(i + (i-1)*k)+k+1
                 for itr_j = (j + (j-1)*k):1:(j + (j-1)*k)+k+1
                  if(new_B(itr_i,itr_j) == 0 )
                    %%%%INTERPOALAÇÃOOOOOOO%%%%%
                    var_x = [1, (x - i*h), (x-i*h)^2, (x-i*h)^3];
                    var_y = [1; (y - j*h); (y-j*h)^2; (y-j*h)^3];
                    aux = var_x *COEF;
                    new_B(itr_i, itr_j) = aux * var_y;
                  endif
                  y += dist_y;
                 endfor
                x += dist_x;
                y = j*h;
              endfor
            endfor
        endfor
        
        imshow(new_B);
        input("ENTER");
        
        # GREEEEEEEEEEEEEEEEEEN
        
        l = c = 1;
        
        for i = 1:1:n-1
            for j = 1:1:n-1
              
              if(i == 1)
                delij = 0; # ??? sla
              elseif( j == 1)
                delij = (double (GREEN(i-1, j+1)) - double (GREEN(i-1,j)))/h;
              else
                delij = (double (GREEN(i-1, j+1)) - double(GREEN(i-1, j-1)))/(2*h);
              endif
              
              
              # (a23) derivada parcial de y de (i-1, j+1)
              if(i == 1)
                deliJ = 0;
              elseif(j == n-1)
                deliJ = (double(GREEN(i-1,j)) - double(GREEN(i-1, j-1)))/h;
              else
                deliJ = (double(GREEN(i-1, j+2)) - double(GREEN(i-1, j)))/(2*h);
              endif
              
              # (a32) derivada parcial de y de (i+2, j)
              if(i == n-1)
                delIj = 0;
              elseif(j == 1)
                delIj = (double(GREEN(i+2, j+1)) - double(GREEN(i+2, j)))/h;
              else
                delIj = (double(GREEN(i+2, j+1)) - double(GREEN(i+2, j-1)))/(2*h);
              endif
              
              # (a33) derivada parcial de y de (i+2, j+1)
              if(i == n-1)
                delIJ = 0;
              elseif(j == n-1)
                delIJ = (double (GREEN(i+2, j)) - double(GREEN(i+2, j-1)))/h;
              else
                delIJ = (double (GREEN(i+2, j+2)) - double(GREEN(i+2, j)))/(2*h);
              endif
            
              % OBS CASOS ESPECIAIS SÃO AS BORDAS!! CHECAR AS BORDAS!!!
              
              a00 = double (GREEN(i,j));
              a01 = double (GREEN(i, j+1));
              
              if(j == 1) # ok
                a02 = (double (GREEN(i, j+1)) - double(GREEN(i,j)))/h;
              else
                a02 = (double (GREEN(i, j+1)) - double(GREEN(i, j-1)))/(2*h);
              endif
              
              if(j == n-1) # ok
                a03 = (double(GREEN(i, j)) - double(GREEN(i, j-1)))/h;
              else
                a03 = (double(GREEN(i, j+2)) - double(GREEN(i, j)))/(2*h);
              endif
              
              a10 = double (GREEN(i+1, j));
              a11 = double (GREEN(i+1, j+1));
              
              if(j == 1) # ok
                a12 = (double (GREEN(i+1, j+1)) - double (GREEN(i+1,j)))/h;
              else
                a12 = (double (GREEN(i+1, j+1)) - double(GREEN(i+1, j-1)))/(2*h);
              endif
              
              if(j == n-1) # ok
                a13 = (double(GREEN(i+1, j)) - double(GREEN(i+1, j-1)))/h;
              else
                a13 = (double(GREEN(i+1, j+2)) - double(GREEN(i+1, j)))/(2*h);
              endif
              
              if(i == 1)  # ok
                a20 = (double (GREEN(i+1, j)) - double (GREEN(i, j)))/(h);
              else
                a20 = ( double (GREEN(i+1, j)) - double (GREEN(i-1, j)))/(2*h);
              endif
              
              if(i == 1) # ok
                a21 = (double (GREEN(i+1, j+1)) - double (GREEN(i, j+1)))/(h);
              else
                a21 = (double (GREEN(i+1, j+1)) - double (GREEN(i-1, j+1)))/(2*h);
              endif
              
              a22 = (a12 - delij)/(2*h);
              a23 = (a13 - deliJ)/(2*h);
              
              if(i == n-1) # ok
                a30 = (double (GREEN(i, j)) - double (GREEN(i-1, j)))/(h);
              else
                a30 = (double (GREEN(i+2, j)) - double(GREEN(i, j)))/(2*h);
              endif
            
              if(i == n-1) # ok
                a31 = (double (GREEN(i, j+1)) - double (GREEN(i-1, j+1)))/(h);
              else
                a31 = (double (GREEN(i+2, j+1)) - double (GREEN(i, j+1)))/(2*h);
              endif
              
              a32 = (delIj - a02)/(2*h);
              a33 = (delIJ - a03)/(2*h);
              
              COEF = [ a00, a01, a02, a03;
                       a10, a11, a12, a13;
                       a20, a21, a22, a23;
                       a30, a31, a32, a33 ];
                       
              COEF = BI*COEF;
              COEF = COEF*BTI;
              
              dist_x = h/(k+1);
              x = i*h;
              dist_y = h/(k+1);
              y = j*h;
              
              var_x = [ 1, 1, 1, 1 ];
              var_y = [ 1; 1; 1; 1 ];
              
              itr_i = i + (i-1)*k; # itr_i é o equivalente da posição i calculada na nova matriz
              itr_j = j + (j-1)*k; # itr_j é o equivalente da posição j calculada na nova matriz
              
              # INÍCIO DA INTERPOLAÇÃO PARA OS (K+2)x(K+2) ELEMENTOS
              for itr_i = (i + (i-1)*k):1:(i + (i-1)*k)+k+1
                 for itr_j = (j + (j-1)*k):1:(j + (j-1)*k)+k+1
                  if(new_G(itr_i,itr_j) == 0 )
                    %%%%INTERPOALAÇÃOOOOOOO%%%%%
                    var_x = [1, (x - i*h), (x-i*h)^2, (x-i*h)^3];
                    var_y = [1; (y - j*h); (y-j*h)^2; (y-j*h)^3];
                    aux = var_x *COEF;
                    new_G(itr_i, itr_j) = aux * var_y;
                  endif
                  y += dist_y;
                 endfor
                x += dist_x;
                y = j*h;
              endfor
            endfor
        endfor
        
        imshow(new_G);
        
        input("ENTER");
        
        # Concantenação das matrizes de cores, formando a imagem final
        new_img = cat(3,new_R,new_G,new_B);
        
        imshow(new_img);               % mostrando imagem RGB
        imwrite(new_img, 'decompressed.png');   % salvando imagem RGB
        
      otherwise # ??
        disp("Método inválido...");
        
    endswitch
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
  else
    disp("A imagem inserida não é quadrada. Por favor insira uma imagem nxn.");
    
  endif
  
endfunction