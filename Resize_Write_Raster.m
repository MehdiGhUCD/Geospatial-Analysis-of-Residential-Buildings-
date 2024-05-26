function Resize_Write_Raster(im_name,new_resolution)
[Z,R] = readgeoraster(im_name);Z=double(Z);
info = geotiffinfo(im_name);
Z(Z==65535)=0;Z(Z>0)=1;Z(Z<0)=0;
% Define new resolution
[Z2,R2] = mapresize(Z,R,1/new_resolution,'nearest');

% Calculate resampling factor
resampling_factor = new_resolution / info.PixelScale(1);

% Perform resampling and aggregation
resampled_raster = blockproc(Z, [resampling_factor resampling_factor], ...
    @(block_struct) sum(block_struct.data(:)));
resampled_raster=Imresize(resampled_raster,Z2);
resampled_raster=floor((resampled_raster/(new_resolution^2))*100);
% Write the resampled raster to a new geotiff file
geotiffwrite(strcat(im_name(1:end-4),'_Resample_percentage.tif'), resampled_raster, R2,'GeoKeyDirectoryTag', info.GeoTIFFTags.GeoKeyDirectoryTag);
