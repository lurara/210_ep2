
function teste (originalImg)
  #[img, cmap] = imread(originalImg);
  img  = imread(originalImg);
  imfinfo(originalImg)
  #iscolormap(cmap)
  #imshow(img, cmap);
  
  #imwrite(img, cmap, 'nUEVO.png');
  imwrite(img, 'nuevo.png');
endfunction
  