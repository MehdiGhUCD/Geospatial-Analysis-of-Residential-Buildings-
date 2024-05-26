clc;clear;
My_dist=100;
proj = projcrs(32629);

tb_ber=readtable('Dublin, residetial buildings09052024_insideBBox.csv');
tb_ber(:,1:25)=[];
Lat_ber=tb_ber.LATITUDE;Lon_ber=tb_ber.LONGITUDE;
[x_ber,y_ber] = projfwd(proj,Lat_ber,Lon_ber);
tb_poly=readtable('Building_poly_centriod.csv');
area_poly=tb_poly.SHAPE_Area;
Lat_poly=tb_poly.Y_center;Lon_poly=tb_poly.X_center;
[x_poly,y_poly] = projfwd(proj,Lat_poly,Lon_poly);

m=10000;
tic
n_ber=length(x_ber);n_poly=length(x_poly);
index_subset_ber_start=1:m:n_ber;index_subset_ber_start(end)=[];
index_subset_ber_end=0:m:n_ber;index_subset_ber_end(1)=[];
index_subset_ber_end(end)=n_ber;
U_area_ber=zeros(size(x_ber));
for k=1:length(index_subset_ber_end)
    id_bersub=index_subset_ber_start(k):index_subset_ber_end(k);
    xber_sub=x_ber(id_bersub);  yber_sub=y_ber(id_bersub);

    mk=length(xber_sub);    N=n_poly*mk;
    % BER Vector Construction
    tic
    Xber=repmat(xber_sub,1,n_poly);Xber=Xber';Xber=Xber(:);
    Yber=repmat(yber_sub,1,n_poly);Yber=Yber';Yber=Yber(:);
    Xpoly=repmat(x_poly,1,mk);Xpoly=Xpoly(:);
    Ypoly=repmat(y_poly,1,mk);Ypoly=Ypoly(:);
    Di=((Xber-Xpoly).^2+(Yber-Ypoly).^2).^0.5;
toc
tic
Diii=zeros(10000,416900);
for j1=1:10000
    for j2=1:416900
        Diii(j1,j2)=((xber_sub(j1)-x_poly(j2))^2+(yber_sub(j1)-y_poly(j2))^2)^0.5;

    end
end
toc
    Area_poly=repmat(area_poly,1,mk);Area_poly=Area_poly(:);
    Id=find(Di>My_dist);Area_poly(Id)=0;
    Area_poly=reshape(Area_poly,n_poly,mk);
    U_area_ber(id_bersub)=sum(Area_poly,'omitmissing');
end
tb_ber.Ur_complx=U_area_ber;
toc
% % Radious_calculate_building_complexity
% % Elapsed time is 549.582201 seconds.
% % 549.5/60
% % 
% % ans =
% % 
% %           9.15833333333333
% writetable(tb_ber,'BER_Residential_index.csv')