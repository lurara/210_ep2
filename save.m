
        
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
        