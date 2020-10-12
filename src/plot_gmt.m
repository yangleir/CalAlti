% Plot map with GMT (mainly pswiggle).
% Plot the wet pd slope to check the land influence.

% Author: Yang Lei
% 2020-08-20

function plot_gmt(pass_num,min_cir,max_cir,sat)

if sat==1
    temp='..\test\ja2_check\';
elseif sat==4
    temp='..\test\ja3_check\';
elseif sat==3
    temp='..\test\hy2_check\';    
end

% Find the best pass. (data not missed)
for i=min_cir:max_cir
        temp1=check_circle(i);% ���ú������ж�circle��λ����
        temp2=num2str(temp1);
        if sat==3
            temp3=temp2(2:5);% �����λ�����ַ�����
        else
            temp3=temp2(3:5);% �����λ�����ַ�����
        end        
        t1=check_circle(pass_num);
        t2=num2str(t1);
        if sat==3
            temp31=t2(2:5);% �����λ�����ַ�����
        else
            temp31=t2(3:5);% �����λ�����ַ�����
        end        
        tmp=strcat('_',temp31);
        temp4= strcat(temp,temp3,tmp,'.txt');
        temp5= strcat('X',temp3,tmp);
        s=dir(temp4);
    if exist(temp4,'file') && s.bytes~=0
%         temp4;
        disp(temp4);
        load (temp4)
        temp6=eval(temp5);% �ַ�����������ʹ�ã�temp5��load�����ı�����һ����
        lent(i)=length(temp6(:,3));% As for HY-2B, many radiometer measurements were lost and matix values are 0.
    end
    
end 

[ma,location]=max(lent);
i=location; % The best circle.
temp1=check_circle(i);% ���ú������ж�circle��λ����
temp2=num2str(temp1);
if sat==3
    temp3=temp2(2:5);% �����λ�����ַ�����
else
    temp3=temp2(3:5);% �����λ�����ַ�����
end
% temp3=temp2(3:5);% �����λ�����ַ�����
t1=check_circle(pass_num);
t2=num2str(t1);
% t3=t2(3:5);% �����λ�����ַ�����
if sat==3
    temp31=t2(2:5);% �����λ�����ַ�����
else
    temp31=t2(3:5);% �����λ�����ַ�����
end
tmp=strcat('_',temp31);
temp4= strcat(temp,temp3,tmp,'.txt');
temp5= strcat('X',temp3,tmp);
load (temp4);
full_pass=eval(temp5);

% Interpolate coordinates
s_lat=full_pass(2:ma-1,2); % remove the head and tail.
s_lon=full_pass(2:ma-1,1);
wet_full=full_pass(:,3);
wet_full_f=wet_full-mean(wet_full);
wet_ful_f_plot=[full_pass(:,1:2) wet_full_f];

k=1;
d=[]; % Must clear the array in each loop.
y=[];
for i=min_cir:max_cir
% for i= [200] % ֻ����һ�����ڵ�һ��pass���ݣ�����i [200] ��ʾ200����
% i
        
        temp1=check_circle(i);% ���ú������ж�circle��λ����
        temp2=num2str(temp1);
        if sat==3
            temp3=temp2(2:5);% �����λ�����ַ�����
        else
            temp3=temp2(3:5);% �����λ�����ַ�����
        end
%         temp3=temp2(3:5);% �����λ�����ַ�����
        t1=check_circle(pass_num);
        t2=num2str(t1);
        if sat==3
            temp31=t2(2:5);% �����λ�����ַ�����
        else
            temp31=t2(3:5);% �����λ�����ַ�����
        end        
%         t3=t2(3:5);% �����λ�����ַ�����
        tmp=strcat('_',temp31);
        temp4= strcat(temp,temp3,tmp,'.txt');
        temp5= strcat('X',temp3,tmp);
        s=dir(temp4);
    if exist(temp4,'file') && s.bytes~=0 
%         temp4;
%         disp(temp4);
        load (temp4)
        temp6=eval(temp5);% �ַ�����������ʹ�ã�temp5��load�����ı�����һ����
        latitude=temp6(:,2);
        longitude=temp6(:,1);
        points=temp6(:,3);
        for ii=2:length(points)
            dy=points(ii)-points(ii-1);
            dx=latitude(ii)-latitude(ii-1);
            d(ii-1)=dy/dx;%б��
            y(ii-1)=(latitude(ii)+latitude(ii-1))/2;
%             x(ii-1)=(longitude(ii)+longitude(ii-1))/2;
        end
%         length(d)
%         length(y)
        slope_inter=interp1(y',d',s_lat,'pchip');
        d=[]; % Must clear the array in each loop.
        y=[];
        
        slope=[s_lon s_lat slope_inter];
        
        errors=std(slope_inter);

        if k==1 % Here I only plot one time. 
            gmt('gmtset MAP_FRAME_WIDTH = 0.02c FONT_LABEL 7 MAP_LABEL_OFFSET 5p ')
            gmt('gmtset FORMAT_GEO_MAP = ddd:mm:ssF')
            info=gmt('info -I0.01 ',temp6); 

            bound=char(info.text);
            len_b=length(bound);
            bounds= strsplit(bound(3:len_b),'/');
            bounds=str2num(char(bounds));
            mi_lon=floor(bounds(1)-1);
            ma_lon=ceil((bounds(2))+1);
            mi_lat=floor((bounds(3))-0.5);
            ma_lat=ceil((bounds(4))+0.5);
            bound=['-R',num2str(mi_lon),'/',num2str(ma_lon),'/',num2str(mi_lat),'/',num2str(ma_lat)];
            order=['pscoast ',bound,' -Jm122/37/1:5000000  -Bga -BSWen -Df -W1 -Glightyellow -K > ../temp/test.ps'];
            gmt(order);  
            
            
        end
        
        if errors<150
            slope_mean(k,:)=slope_inter;
            k=k+1;
            gmt('pswiggle  -R -J  -Z50 -Wthinnest,red -O -K -t70 >> ../temp/test.ps ', slope)
        end     

    end 
end 

s=mean(slope_mean,1);
slopes=[s_lon s_lat s'];

gmt('psxy -J -R -W1.67c,black -O -K -t70 >> ../temp/test.ps',full_pass(:,1:3)) % The diameter is 50km based on the projection scalor.
order='psxy  -J -R -Sc0.2c -Gblack -O  -K >> ../temp/test.ps';
% cpt = gmt('makecpt -Crainbow -E24', wet_full);
gmt(order,full_pass(:,1:3));   
order=['grdmath ',bound,' -A10000/0/4 -Dl -I2m LDISTG = ../temp/dist_to_gshhg_hn2.nc'];
gmt(order);

gmt('grdsample ../temp/dist_to_gshhg_hn2.nc -R -I0.5m -G../temp/file2_hn2.nc')
gmt('grdlandmask -R -Dl -A10000/0/4 -I0.5m -N1/-1 -G../temp/land_mask.nc');
gmt('grdmath ../temp/file2_hn2.nc ../temp/land_mask.nc MUL = ../temp/file.nc' )

out35=gmt('grdcontour ../temp/file.nc -R -C50, -D'); % plot the 35 and 50km line
gmt('psxy -R -J -W4p,green  -K -O >> ../temp/test.ps',out35.data)
% gps=[lon_gps lat_gps];
gmt('psxy ../test/gnss_wet/points_latlon.txt2 -R -J -Sa0.4c -Glightgray -K -O >> ../temp/test.ps');
% !gawk "{print $1, $2, $3}" ../test/gnss_wet/points_latlon.txt >../test/gnss_wet/points_latlon.txt2 
gmt('pswiggle  -R -J  -Z50 -W2p,yellow  -O -K >> ../temp/test.ps ', slopes)
gmt('pstext  ../test/gnss_wet/points_latlon.txt2 -R -J -F+f7p,black+jTL -O  -Gwhite -D0.2/0.1 >> ../temp/test.ps')

% gmt('pswiggle  -R -J  -Z10 -W2p,green  -O  >> test.ps ', wet_ful_f_plot)
gmt('psconvert ../temp/test.ps -P -Tf -A')
return