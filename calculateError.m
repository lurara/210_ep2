function calculateError(originalImg, decompressedImg)
  
  [original, cmap] = imread(originalImg);
  # obs: caso haja cmap, deve ser o mesmo
  [decompressed] = imread(decompressedImg);
  
  # Tamanho das imagens
  [org_width, org_height, dim] = size(original);
    
  % Não é necessário checar pois decompressed é quadrada
  [dec_size, dec_height, dim] = size(decompressed);
    
  # Matrizes RGB
  origR = original(:,:,1);
  origG = original(:,:,2);
  origB = original(:,:,3);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%
  decR = decompressed(:,:,1);
  decG = decompressed(:,:,2);
  decB = decompressed(:,:,3);
  
  if(org_width > org_height)
    org_size = org_height;
    
    while(org_width != org_size)
      origR = origR(1:end-1, 1:end);
      origG = origG(1:end-1, 1:end);
      origB = origB(1:end-1, 1:end);
      
      [org_width, org_height] = size(origR);
    
    endwhile
    
  else
    org_size = org_width;
    
    while(org_height != org_size)
      origR = origR(1:end, 1:end-1);
      origG = origG(1:end, 1:end-1);
      origB = origB(1:end, 1:end-1);
      
      [org_width, org_height] = size(origR);
    
    endwhile
  
  endif
  
  if(dec_size > org_size)
    #disp("ENTROU: maior decompressed");
    
    # Retiro a cada vez 1 linha/coluna
    while(dec_size != org_size)
      decR = decR(1:end-1, 1:end-1);
      decG = decG(1:end-1, 1:end-1);
      decB = decB(1:end-1, 1:end-1);
      
      [dec_size, dec_height] = size(decR);
    endwhile
    
  elseif(org_size > dec_size)
    #disp("ENTROU: menor decompressed");
    
    # Retiro a cada vez 1 linha/coluna
    while(dec_size != org_size)
      origR = origR(1:end-1, 1:end-1);
      origG = origG(1:end-1, 1:end-1);
      origB = origB(1:end-1, 1:end-1);
      
      [org_width, org_height] = size(origR);
      
    endwhile
  endif
  
  # Erros
  errR = norm(double (origR) - double (decR))/(norm(double (origR)));
  errG = norm(double (origG) - double (decG))/(norm(double (origG)));
  errB = norm(double (origB) - double (decB))/(norm(double (origB)));
  
  err = (errR + errG + errB)/3
  
endfunction