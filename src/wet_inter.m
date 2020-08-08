% 计算固定纬度的辐射计大气湿延迟差值、时间差值
% interpolation of  the wet delay to the fixed point.
function [bias_std,bias2,sig_g,dis]=wet_inter(min_cir,max_cir,pass_num,sat,loc,lat_compare,lon_gps,lat_gps)

%     lat3=lat_compare;

    temp11=check_circle(pass_num);% 调用函数，判断circle的位数。
    temp21=num2str(temp11);
    
    if sat==3
        temp31=temp21(2:5);% 组成三位数的字符串。
    else
        temp31=temp21(3:5);% 组成三位数的字符串。
    end
    
    % loop the `lat3`, save the STD of bias to matrix.
    tmp=length(lat_compare);
%     sig_bias_r_g=[];
    
    for ii=1:tmp
        lat3=lat_compare(ii);
        
        if sat==1
            fid4=fopen('..\test\ja2_check\pca_wet.txt','w');
            fid5=fopen('..\test\ja2_check\pca_wet_model.txt','w');
            temp='..\test\ja2_check\';
        elseif sat==4
            fid4=fopen('..\test\ja3_check\pca_wet.txt','w');
            fid5=fopen('..\test\ja3_check\pca_wet_model.txt','w');
            temp='..\test\ja3_check\';
        elseif sat==3
            fid4=fopen('..\test\hy2_check\pca_wet.txt','w');
            fid5=fopen('..\test\hy2_check\pca_wet_model.txt','w');
            temp='..\test\hy2_check\';
        end  
        
        for i=min_cir:max_cir
    %         i;
                temp1=check_circle(i);% 调用函数，判断circle的位数。
                temp2=num2str(temp1);
                if sat==3
                    temp3=temp2(2:5);% 组成三位数的字符串。
                else
                    temp3=temp2(3:5);% 组成三位数的字符串。
                end
                tmp=strcat('_',temp31);
                temp4= strcat(temp,temp3,tmp,'.txt');
                temp5= strcat('X',temp3,tmp);

            if exist(temp4,'file')

                load (temp4) %读入SSH文件
                temp6=eval(temp5);% 字符串当做变量使用，temp5和load进来的变量名一样。
                aa=size(temp6);

                if aa(1)>10 % 表示有效点数大于20个，占总数的一半。这个值可以更具总数多少修改。
                    pca_wet=interp1(temp6(:,2),temp6(:,3),lat3,'pchip');
                    pca_wet_model=interp1(temp6(:,2),temp6(:,4),lat3,'pchip');
                    lon3=interp1(temp6(:,2),temp6(:,1),lat3,'pchip');
                    tim_pca=interp1(temp6(:,2),temp6(:,5),lat3,'pchip');
    %                 tmp=datestr(tim_pca/86400+datenum('2000-01-1 00:00:00'))%
    %                 trasform the seconds to normal data format
                    fprintf(fid4,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_wet,i);% 保存
                    fprintf(fid5,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_wet_model,i);% 保存
                end

            end

        end 
        
        % compare
        [bias2,sig_g]=wet_cal_G_S(sat,loc);
        % three sigma0 edit.
        [bias_std]=wet_filter_save(bias2,sat,min_cir,max_cir);
%         sig_bias_r_g(ii)=bias_std;
        
        input=[lon_gps lat_gps];
        order=strcat('mapproject -G',num2str(lon3),'/',num2str(lat3),'+i+uk -fg');
        dis = gmt (order,input);
        % 
        Q=['finish interp at latitude:', num2str(lat3),'; distance to GNSS site:',num2str(dis.data(3))];
        disp(Q);
        fclose('all');
        
    end
    
    % test 
%     figure (234)
%     plot(sig_bias_r_g)

return