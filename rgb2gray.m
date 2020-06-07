function rgb2gray(original)
  img = imread(original);
  
  RED = img(:,:,1);     # Red 
  GREEN = img(:,:,2);   # Green
  BLUE = img(:,:,3);    # Blue
  
  % Imagem grayscale
  % gray = rgb2gray(img); - como não tem, vou fazer o peso
  % https://www.mathworks.com/matlabcentral/answers/159282-convert-from-rgb-to-grayscale-without-rgb2gray
  gray = .299*double(RED) + .587*double(GREEN) + .114*double(BLUE);
  gray = uint8(gray);
  %imshow(gray);
  
  imwrite(gray, 'gray.png', 'Quality', 100);
  
endfunction