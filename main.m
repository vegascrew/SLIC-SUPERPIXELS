I = imread('Brain.jpeg');
[A,D]=Harshitslic(I,20,10,3,10);
BW=boundarymask(A);
imshow(imoverlay(I,BW,'red'));
