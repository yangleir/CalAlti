% ������������������PCAλ�ã�������ϳ�PCA��SSH����������
% �����ļ�����
function ja2_pca_ssh(min_cir,max_cir,pass_num,lat_gps,lon_gps,loc)

% lat_gps=36.2667;% ǧ�����鳱վ������
% lon_gps=121.3850;
fid4=fopen('..\test\ja2_check\pca_ssh.txt','w');
    temp='..\test\ja2_check\';
    for i=min_cir:max_cir
        tmp=['cycle: ',num2str(i)];
        disp(tmp)
%         i
            temp1=check_circle(i);% ���ú������ж�circle��λ����
            temp2=num2str(temp1);
            temp3=temp2(3:5);% �����λ�����ַ�����
            tmp=strcat('_',num2str(pass_num));
            temp4= strcat(temp,temp3,tmp,'.dat');
            temp5= strcat('X',temp3,tmp);
            
        if exist(temp4,'file')
            
            load (temp4) %����SSH�ļ�
            temp6=eval(temp5);% �ַ�����������ʹ�ã�temp5��load�����ı�����һ����
            aa=size(temp6);
            
            if aa(1)>5 % ��ʾ��Ч��������5����ռ������һ�롣���ֵ���Ը������������޸ġ�
                if strcmp(loc,'zmw')
%                     [lat3,lon3,tim_pca]=pca(temp4,lat_gps,lon_gps); % ���ú���������PCA
                    lat3=39.8046; % �����ֵ��Jason-2�����������й�ϵ�������ʵ��ĵ�����
                    pca_ssh=interp1(temp6(:,2),temp6(:,4),lat3,'PCHIP');
                    tim_pca=interp1(temp6(:,2),temp6(:,3),lat3,'liner');
                    lon3=interp1(temp6(:,2),temp6(:,1),lat3,'liner');
                    if isnan(tim_pca)==0
                        fprintf(fid4,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_ssh,i);% ����
                    end
                else 
                    [lat3,lon3,tim_pca]=pca(temp4,lat_gps,lon_gps); % ���ú���������PCA
                    pca_ssh=interp1(temp6(:,2),temp6(:,4),lat3,'PCHIP');
                    fprintf(fid4,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_ssh,i);% ����

                end
                
            end
            
        end
        
    end 
%     workdir;
%     cd .\qianliyan_tg_cal
%     !grad
%     workdir;
disp('Finish!')
fclose('all');
    
return