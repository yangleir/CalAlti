% kouba function
% -input: filename
% -output: kouba parameter
function [kouba_p]=kouba(filename,lon1,lat1)
    
    filepath=filename;
    lat_gps=lat1;
    lon_gps=lon1;
    lat=ncread(filepath,'latitude'); % 1d
    lon=ncread(filepath,'longitude'); % 1d
%     time=ncread(filepath,'time'); % 1d, hours since 1900-01-01 00:00:00.0
    geo=ncread(filepath,'z'); % 4D:lon,lat,level,time
    hum=ncread(filepath,'q'); % 
    air_t=ncread(filepath,'t'); % 
    level=ncread(filepath,'level'); % pressure level
    geo_h=geo/9.80665; % transform the geopotential to height.

   %% interpolation of value to GNSS sites

        k1=0;
        for i=1:length(lat)
            if lat(i)>=lat_gps && lat(i+1)<lat_gps
                k1=i;
                break
            end
        end

        k2=0;
        for i=1:length(lon)
            if lon(i)<=lon_gps && lon(i+1)>lon_gps
                k2=i;
                break
            end
        end

%         X = ['latitude: ',num2str(k1),' longitude: ',num2str(k2)];
%         disp(X)
    %% calculate the Kouba parameter using least squares.

    % First, get the WPD at each level.

    for ii=0:7 % hour
        k=1;
        for i=2:23

            hum_gnss=hum(k2,k1,1:i,ii+1);% the 00:00 h
            air_gnss=air_t(k2,k1,1:i,ii+1);
            len=i;
            hum_gnss=reshape(hum_gnss,len,1);
            air_gnss=reshape(air_gnss,len,1);
            % plot(level,hum_gnss)
            wet_pd(ii+1,k)=(1.116454*1e-3*trapz(double(level(1:i)),hum_gnss)+17.66543828*trapz(double(level(1:i)),hum_gnss./air_gnss))*(1+0.0026*cosd(2*lat_gps));
            geo_height(ii+1,k)=geo_h(k2,k1,i,ii+1);
            k=k+1;
        end
        
%         figure(10)
%         plot(wet_pd(ii+1,:),geo_height(ii+1,:));hold on
        
        % Calculate Kouba
        x=geo_height(ii+1,:)';
        y=wet_pd(ii+1,:)';
        myfittype = fittype([num2str(wet_pd(ii+1,k-1)),'*exp((',num2str(geo_height(ii+1,k-1)),'-x)/c)'],...
            'dependent',{'y'},'independent',{'x'},...
            'coefficients',{'c'});
        myfit = fit(x,y,myfittype,'StartPoint',(2000));
        kouba_p(ii+1)=myfit.c;

    end
   
    
return