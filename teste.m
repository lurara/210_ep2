function teste(originalImg)
  
  [original, cmap] = imread(originalImg);
  [org_width, org_height, dim] = size(original);
  
  A = original(1:(end-1), 1:end-1);
  
  [a_width, a_height, dim] = size(A);
  
  a_width
  a_height
  dim
  
endfunction