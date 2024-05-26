function Imout=Imresize(im1,im2)
% Conver Im1 (Original) to Im2 (Resized) image
[n1,m1]=size(im1);[n2,m2]=size(im2);
if (n1>=n2 && m1>=m2)
    Imout=im1(1:n2,1:m2);
elseif (n1<=n2 && m1>=m2)
    Imout=zeros(n2,m2);
    Imout(1:n1,:)=im1(:,1:m2);

elseif (n1<=n2 && m1<=m2)
    Imout=zeros(n2,m2);
    Imout(1:n1,1:m1)=im1;
else
    disp('Error')
end
