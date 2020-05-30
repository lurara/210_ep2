function calculateError(originalImg, decompressedImg)
  
  [original, cmap] = imread(originalImg);
  # obs: caso haja cmap, deve ser o mesmo
  [decompressed] = imread(decompressedImg);
  
  # Tamanho das imagens
  [org_width, org_height, dim] = size(original);
  [dec_width, dec_height, dim] = size(decompressed);
  
  # Matrizes RGB
  origR = original(:,:,1);
  origG = original(:,:,2);
  origB = original(:,:,3);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%
  decR = decompressed(:,:,1);
  decG = decompressed(:,:,2);
  decB = decompressed(:,:,3);
  
  # Erros
  errR = norm(origR - decR)/(norm(origR));
  errG = norm(origG - decG)/(norm(origG));
  errB = norm(origB - decB)/(norm(origB));
  
  err = (errR + errG + errB)/3
  
endfunction