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
      new_R = -1*ones(p);
      
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
      new_G = -1*ones(p);
              
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
      new_B = -1*ones(p);
              
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
        
        for itr = 1:1:dim
          if(itr == 1)
            aux = RED;
            new_aux = new_R;
          elseif(itr == 2)
            aux = GREEN;
            new_aux = new_G;
          else # itr == 3
            aux = BLUE;
            new_aux = new_B;
          endif
          
            
          l = c = 1;
          
          coef = [-1, 1, 1, 1];
          
          for i = 1:1:n-1       # existem k elementos entre cada um dos i
            for j = 1:1:n-1     # existem k elementos entre cada um dos j
              
              # A partir daqui vou iterar para cada quadrado
              # se for o primeiro, o método é diferente
              # mas nos outros oque vou fazer é interolar
              # para todos quadrados abaixo da primeira linha do quadrado
              # porque essa já vai ter sido interpolada anteriormente
              
              % OBS PRECISO CHECAR SE i+1 SE ENCONTRA NO INTERVALO
              coef(1) = double (aux(i, j));
              coef(2) = (double (aux( i, j+1 )) - coef(1));
              coef(3) = (double (aux( i+1, j )) - coef(1));
              coef(4) = (double (aux(i+1,j+1)) - coef(1) - coef(2) - coef(3))/(h*h);
              
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
                
                  if(new_aux(itr_i,itr_j) == -1 ) % <-- isso é pra não calcular nova cor para pixels já visitados
                    new_aux(itr_i,itr_j) = coef(1) + coef(3)*(x-i*h) + coef(2)*(y-j*h) + coef(4)*(x-i*h)*(y-j*h);
                  endif                
                  y += dist_y;
                  
                endfor
                x += dist_x;
                y = j*h;
              endfor
            endfor
          endfor          
          
          if(itr == 1)
            new_img = uint8 (new_aux);
          else
            new_img = cat(3, new_img, uint8 (new_aux));
          endif
          
        endfor
        
        % Mostrando imagem RGB
        imshow(new_img);
        % Salvando imagem RGB     
        imwrite(new_img, 'decompressed.png', 'Quality', 100);
        
      case 2 # Bicúbico
        disp("Método 2: Interpolação bicúbica ");
        
        # As matrizes abaixo serão usadas para calcular os coeficientes.
        B = [ 1, 0, 0, 0; 1, h, h^2, h^3; 0, 1, 0, 0; 0, 1, 2*h, 3*h^2 ];
        BT = B';
        BI = inv(B);
        BTI = inv(BT);
        
        # Para cada uma dessas iterações, o que vou fazer é interpolar para cada
        # conjunto de quadrados. Dessa forma, 
        
        for itr = 1:1:dim
          if(itr == 1)
            aux = RED;
            new_aux = new_R;
          elseif(itr == 2)
            aux = GREEN;
            new_aux = new_G;
          else # itr == 3
            aux = BLUE;
            new_aux = new_B;
          endif
          
          l = c = 1;
        
          coef = [-1, 1, 1, 1];
          
          for i = 1:1:n-1       # existem k elementos entre cada um dos i
              for j = 1:1:n-1   # existem k elementos entre cada um dos j
                
                # "Coeficientes" da matriz
                # (a22) derivada parcial de y de (i-1,j)
                if(i != 1)
                  if(j != 1)
                    delij = (double (aux(i-1, j+1)) - double(aux(i-1, j-1)))/(2*h);
                  else
                    delij = (double (aux(i-1, j+1)) - double(aux(i- 1, j)))/(h);
                  endif
                endif
                
                
                # (a23) derivada parcial de y de (i-1, j+1)
                if(i != 1)
                  if(j != n-1)
                    deliJ = (double(aux(i-1, j+2)) - double(aux(i-1, j+1)))/(2*h);
                  else
                    deliJ = (double(aux(i-1, j+1)) - double(aux(i-1, j)))/(h);
                  endif
                endif
                
                # (a32) derivada parcial de y de (i+2, j)
                if(i != n-1)
                  if( j != 1)
                    delIj = (double(aux(i+2, j+1)) - double(aux(i+2, j-1)))/(2*h);
                  else
                    delIj = (double(aux(i+2, j+1)) - double(aux(i+2, j)))/h;
                  endif
                endif
                
                # (a33) derivada parcial de y de (i+2, j+1)
                if(i != n-1)
                  if(j != n-1)
                    delIJ = (double (aux(i+2, j+2)) - double(aux(i+2, j)))/(2*h);
                  else
                    delIJ = (double (aux(i+2, j+1)) - double(aux(i+2, j)))/h;
                  endif
                endif
              
                % OBS CASOS ESPECIAIS SÃO AS BORDAS!! CHECAR AS BORDAS!!!
                # Abaixo, construção dos elementos da matriz:
                
                a00 = double (aux(i,j));
                a01 = double (aux(i, j+1));
                a10 = double (aux(i+1, j));
                a11 = double (aux(i+1, j+1));
                
                if(j == 1) # restrição de borda
                  a02 = (double (aux(i, j+1)) - double(aux(i,j)))/h;
                  a12 = (double (aux(i+1, j+1)) - double (aux(i+1,j)))/h;
                else
                  a02 = (double (aux(i, j+1)) - double(aux(i, j-1)))/(2*h);
                  a12 = (double (aux(i+1, j+1)) - double(aux(i+1, j-1)))/(2*h);
                endif
                
                if(j == n-1) # restrição de borda
                  a03 = (double(aux(i, j+1)) - double(aux(i, j)))/h;
                  a13 = (double(aux(i+1, j+1)) - double(aux(i+1, j)))/h;
                else
                  a03 = (double(aux(i, j+2)) - double(aux(i, j)))/(2*h);
                  a13 = (double(aux(i+1, j+2)) - double(aux(i+1, j)))/(2*h);
                endif
                
                if(i == 1) # restrição de borda
                  a20 = (double (aux(i+1, j)) - double (aux(i, j)))/(h);
                  a21 = (double (aux(i+1, j+1)) - double (aux(i, j+1)))/(h);
                  a22 = (a12 - a02)/h;       
                  a23 = (a13 - a03)/h;
                else
                  a20 = ( double (aux(i+1, j)) - double (aux(i-1, j)))/(2*h);
                  a21 = (double (aux(i+1, j+1)) - double (aux(i-1, j+1)))/(2*h);
                  a22 = (a12 - delij)/(2*h);
                  a23 = (a13 - deliJ)/(2*h);
                endif
                
                if(i == n-1) # restrição de borda
                  a30 = (double (aux(i+1, j)) - double (aux(i, j)))/(h);
                  a31 = (double (aux(i+1, j+1)) - double (aux(i, j+1)))/(h);
                  a32 = (a12 - a02)/h;
                  a33 = (a13 - a03)/h;
                else
                  a30 = (double (aux(i+2, j)) - double(aux(i, j)))/(2*h);
                  a31 = (double (aux(i+2, j+1)) - double (aux(i, j+1)))/(2*h);
                  a32 = (delIj - a02)/(2*h);
                  a33 = (delIJ - a03)/(2*h);
                endif
                
                # Construção da matriz de coeficientes:
                
                COEF = [ a00, a01, a02, a03;
                         a10, a11, a12, a13;
                         a20, a21, a22, a23;
                         a30, a31, a32, a33 ];
                         
                COEF = BI*COEF;  # multiplicação pela inversa de B
                COEF = COEF*BTI; # multiplicação pela inversa da transposta de B
                
                dist_x = h/(k+1); # distância em x em equivalente real do pixel
                x = i*h;          # distância em x em equivalente real de p_i
                dist_y = h/(k+1); # distância em y em equivalente real do pixel
                y = j*h;          # distância em y em equivalente real de p_j
                
                var_x = [ 1, 1, 1, 1 ];
                var_y = [ 1; 1; 1; 1 ];
                
                itr_i = i + (i-1)*k; # itr_i é o equivalente da posição i calculada na nova matriz
                itr_j = j + (j-1)*k; # itr_j é o equivalente da posição j calculada na nova matriz
                
                # INÍCIO DA INTERPOLAÇÃO PARA OS (K+2)x(K+2) ELEMENTOS
                for itr_i = (i + (i-1)*k):1:(i + (i-1)*k)+k+1
                   for itr_j = (j + (j-1)*k):1:(j + (j-1)*k)+k+1
                    if(new_aux(itr_i,itr_j) == -1 ) # checo se posição visitada
                      var_x = [1, (x - i*h), (x-i*h)^2, (x-i*h)^3];
                      var_y = [1; (y - j*h); (y-j*h)^2; (y-j*h)^3];
                      aux_c = var_x *COEF;
                      new_aux(itr_i, itr_j) = aux_c * var_y;
                    endif
                    y += dist_y;
                   endfor
                  x += dist_x;
                  y = j*h;
                endfor
              endfor
          endfor
          
          # Construção da imagem RGB
          if(itr == 1)
            new_img = uint8 (new_aux);
          else
            new_img = cat(3, new_img, uint8 (new_aux));
          endif
          
        endfor
        
        % Mostrando imagem RGB
        imshow(new_img); 
        % Salvando imagem RGB
        imwrite(new_img, 'decompressed.png', 'Quality', 100);
        
      otherwise # ??
        disp("Método inválido...");
        
    endswitch
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
  else
    disp("A imagem inserida não é quadrada. Por favor insira uma imagem nxn.");
    
  endif
  
endfunction