#decompress: descomprime uma imagem nxn

function decompress(compressedImg, method, k, h)
 
  # Para receber o colormap exato da imagem:
  # uso o imread, recebendo o cmap e img
  [img, cmap] = imread(compressedImg);
  
  # Tamanho da imagem
  [img_width, img_height] = size(img); 
  
  # Requisito para rodar esta função:
  if(img_width == img_height)
    n = img_height;
    
    # Novo número de pixels de linhas/colunas
    p = n + (n-1)*k;
    printf("O valor gerado para p é %d.\n", p);
    
    #new_img = eye (p); % nova imagem descomprimida
    new_img = zeros(p);
    
    l = 1; % indica a linha na matriz original 
    c = 1; % indica a coluna
    
    # Percorre apenas valores da matriz original
    for i = 1:1:n
      for j = 1:1:n
        new_img (l,c) = img(i,j);
        c += k+1; % avançamos para o próximo múltiplo de k+1  
      endfor
      l += k+1; % avançamos para a próxima linha
      c = 1; % voltamos a coluna pro começo
    endfor
    
    # Desta forma, a matriz resultante possui, nos k espaços
    # entre as linhas e colunas originais, 0s como elementos
    
    imshow(new_img, cmap);
    
  else
    disp("A imagem inserida não é quadrada. Por favor insira uma imagem nxn.");
  endif
  
endfunction