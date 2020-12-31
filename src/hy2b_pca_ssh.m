% ������������������PCAλ�ã�������ϳ�PCA��SSH����������
% �����ļ�����
function hy2b_pca_ssh(min_cir,max_cir,pass_num,lat_gps,lon_gps,loc)

% lat_gps=36.2667;% ǧ�����鳱վ������
% lon_gps=121.3850;
fid4=fopen('..\test\hy2_check\pca_ssh.txt','w');
temp='..\test\hy2_check\';
    for i=min_cir:max_cir
%         if i~=40 % cycle 40 is abnormal
           
            temp1=check_circle(i);% ���ú������ж�circle��λ����
            temp2=num2str(temp1);
            temp3=temp2(2:5);% �����λ�����ַ�����
            tmp=strcat('_0',num2str(pass_num));
            temp4= strcat(temp,temp3,tmp,'.dat');
            temp5= strcat('X',temp3,tmp);
            
            if exist(temp4,'file')

                load (temp4) %����SSH�ļ�
                temp6=eval(temp5);% �ַ�����������ʹ�ã�temp5��load�����ı�����һ����
                aa=size(temp6);

                if aa(1)>5 % ��ʾ��Ч��������5����ռ������һ�롣���ֵ���Ը������������޸ġ�
                    if strcmp(loc,'zmw') ||  strcmp(loc,'bzmw') % Do not use the PCA because of the land contamination.
    %                     [lat3,lon3,tim_pca]=pca(temp4,lat_gps,lon_gps); % ���ú���������PCA
                        lat3=39.8046; % �����ֵ��Jason-2�����������й�ϵ�������ʵ��ĵ�����
                        pca_ssh=interp1(temp6(:,2),temp6(:,4),lat3,'PCHIP');
                        tim_pca=interp1(temp6(:,2),temp6(:,3),lat3,'liner');
                        lon3=interp1(temp6(:,2),temp6(:,1),lat3,'liner');
                        if isnan(tim_pca)==0
                            fprintf(fid4,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_ssh,i);% ����
                        end
                    elseif  strcmp(loc,'zhws') % Do not use the PCA because of the land contamination.
                        lat3=21.916666; % �����ֵ��Jason-2�����������й�ϵ�������ʵ��ĵ�����
                        pca_ssh=interp1(temp6(:,2),temp6(:,4),lat3,'PCHIP');
                        tim_pca=interp1(temp6(:,2),temp6(:,3),lat3,'PCHIP');
                        lon3=interp1(temp6(:,2),temp6(:,1),lat3,'PCHIP');
                        if isnan(tim_pca)==0
                            fprintf(fid4,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_ssh,i);% ����
                        end                    
                    else  % bqly
                        [lat3,lon3,tim_pca]=pca(temp4,lat_gps,lon_gps); % ���ú���������PCA
                        pca_ssh=interp1(temp6(:,2),temp6(:,4),lat3,'PCHIP');
                        fprintf(fid4,'%12.6f %12.6f %12.6f %12.6f %3d\n',lat3,lon3,tim_pca,pca_ssh,i);% ����

                    end
                end

            end
%         end
    end 
%     workdir;
%     cd .\qianliyan_tg_cal
%     !grad
%     workdir;
disp('Finish!')
fclose('all');
return