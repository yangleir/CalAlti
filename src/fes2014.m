% reading tide constituents of NetCDF format by matlab.

%% 
function [series1]=fes2014(lat_t,lon_t,time_in)

disp('===========================FES 2014 computing===========================')
namelist = ls ('..\fes2014\FES2014\*.nc');% ����ls���Ժ�dir�滻

% BL=textread('..\fes2014\LAT_LON\lat_lon.txt');%%��ȡ�����ļ�γ�ȡ�����
M=0.0625;
H=0;
G=0;

for n=1:length(namelist)
    filepath=strcat('..\fes2014\FES2014\',namelist(n,1:7));
    lon=ncread(filepath,'lon');
    lat=ncread(filepath,'lat');
    amp_read=ncread(filepath,'amplitude');%%%%%%��λ��cm
    pha_read=ncread(filepath,'phase');%%%%��λ�Ƕȣ���Χ-180��180    
    HC=amp_read';%%%%��λ��cm
    HS=pha_read';
%%%%%%%%%%%%%%%%%%%%%
    for i=1:length(lat_t)      
        x=floor((90+lat_t(i))/M)+1;%%ȷ���õ�����������ھ����е�����
        y=floor(lon_t(i)/M)+1;%%ȷ���õ�����������ھ����е�����
        
        lat_read=lat(x,1);%%����������γ��
        lon_read=lon(y,1);%%���������ľ���
        
        HC1=[HC(x,y),HC(x,y+1);HC(x+1,y),HC(x+1,y+1)];%%%��Χ2*2=4����H
        HS1=[HS(x,y),HS(x,y+1);HS(x+1,y),HS(x+1,y+1)];%%%%%G 


        lat1=lat_read:M:lat_read+M;
        lon1=lon_read:M:lon_read+M;

        id=find(isnan(HC1));%%%%%ȷ����Χ����Ч��ĸ���
        if (sum(id)==0)%%%%%%%%˵����Χ�ĸ���ȫ����Чֵ            
            HH=interp2(lat1,lon1,HC1,lat_t(i),lon_t(i),'spline');
            GG=interp2(lat1,lon1,HS1,lat_t(i),lon_t(i),'spline');            
        elseif (sum(id)>0&&sum(id)<10)%%%%%�ĸ����д�����Чֵ
            aver1=nanmean(nanmean(HC1));
            aver2=nanmean(nanmean(HS1));
            HC1(id)=aver1;
            HS1(id)=aver2;
            HH=interp2(lat1,lon1,HC1,lat_t(i),lon_t(i),'spline');
            GG=interp2(lat1,lon1,HS1,lat_t(i),lon_t(i),'spline');

        elseif(sum(id)==10)%%%%%%�ĸ���ȫΪ��Ч�㣬Ȼ������Χ����Χ4*4=16����
            HC1=[HC(x-1,y-1),HC(x-1,y),HC(x-1,y+1),HC(x-1,y+2);...
                HC(x,y-1),HC(x,y),HC(x,y+1),HC(x,y+2);...
                HC(x+1,y-1),HC(x+1,y),HC(x+1,y+1),HC(x+1,y+2);...
                HC(x+2,y-1),HC(x+2,y),HC(x+2,y+1),HC(x+2,y+2)];%%16��������H
            HS1=[HS(x-1,y-1),HS(x-1,y),HS(x-1,y+1),HS(x-1,y+2);...
                HS(x,y-1),HS(x,y),HS(x,y+1),HS(x,y+2);...
                HS(x+1,y-1),HS(x+1,y),HS(x+1,y+1),HS(x+1,y+2);...
                HS(x+2,y-1),HS(x+2,y),HS(x+2,y+1),HS(x+2,y+2)];%%16��������G
            lat1=lat_read-M:M:lat_read+2*M;
            lon1=lon_read-M:M:lon_read+2*M;

            id=find(isnan(HC1));
            if(sum(id)~=136)%%%%%%%16�����д�����Чֵ126=sum(1:16)
                aver1=nanmean(nanmean(HC1));
                aver2=nanmean(nanmean(HS1));
                HC1(id)=aver1;
                HS1(id)=aver2;    
                HH=interp2(lat1,lon1,HC1,lat_t(i),lon_t(i),'spline');
                GG=interp2(lat1,lon1,HS1,lat_t(i),lon_t(i),'spline');
 
            else%%%%%%%%%%���������ʾ����Ч�㣬����Χ����Χ6*6=36����
                HC1=[HC(x-2,y-2),HC(x-2,y-1),HC(x-2,y),HC(x-2,y+1),HC(x-2,y+2),HC(x-2,y+3);...
                    HC(x-1,y-2),HC(x-1,y-1),HC(x-1,y),HC(x-1,y+1),HC(x-1,y+2),HC(x-1,y+3);...
                    HC(x,y-2),HC(x,y-1),HC(x,y),HC(x,y+1),HC(x,y+2),HC(x,y+3);...
                    HC(x+1,y-2),HC(x+1,y-1),HC(x+1,y),HC(x+1,y+1),HC(x+1,y+2),HC(x+1,y+3);...
                    HC(x+2,y-2),HC(x+2,y-1),HC(x+2,y),HC(x+2,y+1),HC(x+2,y+2),HC(x+2,y+3);...
                    HC(x+3,y-2),HC(x+3,y-1),HC(x+3,y),HC(x+3,y+1),HC(x+3,y+2),HC(x+3,y+3)];%%%%%%�ܱ�36����
                HS1=[HS(x-2,y-2),HS(x-2,y-1),HS(x-2,y),HS(x-2,y+1),HS(x-2,y+2),HS(x-2,y+3);...
                    HS(x-1,y-2),HS(x-1,y-1),HS(x-1,y),HS(x-1,y+1),HS(x-1,y+2),HS(x-1,y+3);...
                    HS(x,y-2),HS(x,y-1),HS(x,y),HS(x,y+1),HS(x,y+2),HS(x,y+3);...
                    HS(x+1,y-2),HS(x+1,y-1),HS(x+1,y),HS(x+1,y+1),HS(x+1,y+2),HS(x+1,y+3);...
                    HS(x+2,y-2),HS(x+2,y-1),HS(x+2,y),HS(x+2,y+1),HS(x+2,y+2),HS(x+2,y+3);...
                    HS(x+3,y-2),HS(x+3,y-1),HS(x+3,y),HS(x+3,y+1),HS(x+3,y+2),HS(x+3,y+3)];%%%%%%�ܱ�36����
                lat1=lat_read-2*M:M:lat_read+3*M;
                lon1=lon_read-2*M:M:lon_read+3*M;
                id=find(isnan(HC1));
                if (sum(id)~=666)%%%%%%36�����д�����Ч�㣬666=sum(1:36)
                    HC1(id)=nanmean(nanmean(HC1));
                    HS1(id)=nanmean(nanmean(HS1));   
                    HH=interp2(lat1,lon1,HC1,lat_t(i),lon_t(i),'spline');
                    GG=interp2(lat1,lon1,HS1,lat_t(i),lon_t(i),'spline');
                else%%%%%%%%36��������Ч�㣬����Χ8*8=64
                    HC1=[HC(x-3,y-3),HC(x-3,y-2),HC(x-3,y-1),HC(x-3,y),HC(x-3,y+1),HC(x-3,y+2),HC(x-3,y+3),HC(x-3,y+4);...
                       HC(x-2,y-3),HC(x-2,y-2),HC(x-2,y-1),HC(x-2,y),HC(x-2,y+1),HC(x-2,y+2),HC(x-2,y+3),HC(x-2,y+4);...
                       HC(x-1,y-3),HC(x-1,y-2),HC(x-1,y-1),HC(x-1,y),HC(x-1,y+1),HC(x-1,y+2),HC(x-1,y+3),HC(x-1,y+4);...
                       HC(x,y-3),HC(x,y-2),HC(x,y-1),HC(x,y),HC(x,y+1),HC(x,y+2),HC(x,y+3),HC(x,y+4);...
                       HC(x+1,y-3),HC(x+1,y-2),HC(x+1,y-1),HC(x+1,y),HC(x+1,y+1),HC(x+1,y+2),HC(x+1,y+3),HC(x+1,y+4);...
                       HC(x+2,y-3),HC(x+2,y-2),HC(x+2,y-1),HC(x+2,y),HC(x+2,y+1),HC(x+2,y+2),HC(x+2,y+3),HC(x+2,y+4);...
                       HC(x+3,y-3),HC(x+3,y-2),HC(x+3,y-1),HC(x+3,y),HC(x+3,y+1),HC(x+3,y+2),HC(x+3,y+3),HC(x+3,y+4);...
                       HC(x+4,y-3),HC(x+4,y-2),HC(x+4,y-1),HC(x+4,y),HC(x+4,y+1),HC(x+4,y+2),HC(x+4,y+3),HC(x+4,y+4)];%%%%%%�ܱ�64����
                    HS1=[HS(x-3,y-3),HS(x-3,y-2),HS(x-3,y-1),HS(x-3,y),HS(x-3,y+1),HS(x-3,y+2),HS(x-3,y+3),HS(x-3,y+4);...
                       HS(x-2,y-3),HS(x-2,y-2),HS(x-2,y-1),HS(x-2,y),HS(x-2,y+1),HS(x-2,y+2),HS(x-2,y+3),HS(x-2,y+4);...
                       HS(x-1,y-3),HS(x-1,y-2),HS(x-1,y-1),HS(x-1,y),HS(x-1,y+1),HS(x-1,y+2),HS(x-1,y+3),HS(x-1,y+4);...
                       HS(x,y-3),HS(x,y-2),HS(x,y-1),HS(x,y),HC(x,y+1),HS(x,y+2),HS(x,y+3),HS(x,y+4);...
                       HS(x+1,y-3),HS(x+1,y-2),HS(x+1,y-1),HC(x+1,y),HS(x+1,y+1),HS(x+1,y+2),HS(x+1,y+3),HS(x+1,y+4);...
                       HS(x+2,y-3),HS(x+2,y-2),HS(x+2,y-1),HC(x+2,y),HS(x+2,y+1),HS(x+2,y+2),HS(x+2,y+3),HS(x+2,y+4);...
                       HS(x+3,y-3),HS(x+3,y-2),HS(x+3,y-1),HC(x+3,y),HS(x+3,y+1),HS(x+3,y+2),HS(x+3,y+3),HS(x+3,y+4);...
                       HS(x+4,y-3),HS(x+4,y-2),HS(x+4,y-1),HC(x+4,y),HS(x+4,y+1),HS(x+4,y+2),HS(x+4,y+3),HS(x+4,y+4)];%%%%%%�ܱ�64����
                    lat1=lat_read-3*M:M:lat_read+4*M;
                    lon1=lon_read-3*M:M:lon_read+4*M;
                    id=find(isnan(HC1));
                    if (sum(id)~=2080)
                        HC1(id)=nanmean(nanmean(HC1));
                        HS1(id)=nanmean(nanmean(HS1));   
                        HH=interp2(lat1,lon1,HC1,lat_t(i),lon_t(i),'spline');
                        GG=interp2(lat1,lon1,HS1,lat_t(i),lon_t(i),'spline');
                    else
                        HH=str2num('NaN');
                        GG=str2num('NaN');
                    end                
                end
            end      
        end    

        if(GG>360)
            GG=GG-360;
        elseif(GG<0)
            GG=GG+360;
        end
        HG1(i,n*2-1)=HH;
        HG1(i,n*2)=GG;
    end
 
end


%%
% Tide simulation by FES2014
[nameu,fu]=textread('..\fes2014\fu.txt','%s%f');
nameu=char(nameu);
tidecon(29,4)=0;

for i=1:length(lat_t) % BLis lat lon   
    for j=1:29
        tidecon(j,1)=HG1(i,j*2-1);
        tidecon(j,3)=HG1(i,j*2);
    end
    % Edit the time and computer the tide by calling t_predic.
        tim1=time_in; % input time
        cd ../fes2014
        series1(i,:)=t_predic(tim1(i),nameu,fu,tidecon);
        cd ../src
end


return
