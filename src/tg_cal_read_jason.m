% ###############################################
% Read the 1Hz Jason-2 data (GDR)
% output the SSH around the CAL site

function tg_cal_read_jason(pass_num,min_cir,max_cir,min_lat,max_lat,dir_0)
fid3 = fopen('..\test\ja2_check\ponits_number.txt','w'); % contains the number of valid data points
fid1 = fopen('..\test\ja2_check\ponits_circle.txt','w'); % contains the latitude and the cycle No.

% ###############################################
% First loop directories
temp1=num2str(pass_num);
dir_nm=strcat(dir_0,temp1,'\'); % directory plus \  EX: C:\Users\yangleir\Documents\aviso\jason2\153
% temp=size(dir_nm);
namelist = ls(fullfile(dir_nm,'*.nc'))% ����ls���Ժ�dir�滻
temp=size(namelist);
file_num=temp(1);
for nm=1:length(namelist)
    
%     temp1=check_circle(nm);% ���ú������ж�circle��λ����
%     temp2=num2str(temp1);
%     temp3=temp2(3:5);% �����λ�����ַ�����
%     dir_nm=strcat(dir_0,pass_num,temp3,'\') % ����ļ�������
%     % Then get the specified pass name, such as the pass 147 which is
%     % needed for checking out.
%     % 
%     % Get all nc file names in present dir. 'Fullfile' is a internal 
%     % function.
%     namelist = ls(fullfile(dir_nm,'*.nc'));% ����ls���Ժ�dir�滻

%      for n=1:file_num
        t1=str2double(namelist(nm,13:15));
        tmp=['cycle: ',num2str(t1)];
        disp(tmp)        
        if ((t1>min_cir) && (t1<max_cir)) % here is pass which you need to output data;009;147
            filepath=strcat(dir_nm,namelist(nm,1:54));
            nc=netcdf.open(filepath,'NC_NOWRITE');
            lat=netcdf.getVar(nc,3);%10-6��
            lon=netcdf.getVar(nc,4);%10-6��
            time=netcdf.getVar(nc,0);%10-6��
            alt=netcdf.getVar(nc,58);%10-3m
            r_ku=netcdf.getVar(nc,61);%10-3m
            dry=netcdf.getVar(nc,82);%10-4m
            if pass_num==138
                wet=netcdf.getVar(nc,83);%10-4m model. consider the land effect. ZMW use wet model
            else
                wet=netcdf.getVar(nc,84);%10-4m
            end 
            
            ino=netcdf.getVar(nc,85);%10-4m
            ssb=netcdf.getVar(nc,88);% sea state bias,10-4m
            inv=netcdf.getVar(nc,148);%inv_bar_corr ,10-4m
            hff=netcdf.getVar(nc,149);%hf_fluctuations_corr  ,10-4m
            ots=netcdf.getVar(nc,150);%ocean tide sole1,10-4m
            set=netcdf.getVar(nc,156);%solid earth tide,10-4m
            pt=netcdf.getVar(nc,157); %pole tide,10-4m
            olt=netcdf.getVar(nc,154); %pole tide,10-4m
            mss=netcdf.getVar(nc,144); %mean_sea_surface ,10-4m

            % for filtering
            surf_t=netcdf.getVar(nc,7); %surface_type
            rain_f=netcdf.getVar(nc,48);%rain_flag 
            ice_f=netcdf.getVar(nc,50);%rain_flag 
            r_rms=netcdf.getVar(nc,67);%range_rms_ku
            r_nums=netcdf.getVar(nc,69);%range_rms_ku
            swh=netcdf.getVar(nc,92);% swh_ku
            wnd=netcdf.getVar(nc,160);% wind speed alti
            sig=netcdf.getVar(nc,110);%sig0_ku 
            sig0_rms=netcdf.getVar(nc,116);%sig0_ku 
            sig0_num=netcdf.getVar(nc,118);%sig0_ku 
            off_nd_ag=netcdf.getVar(nc,136);
            bath=netcdf.getVar(nc,147);%
            
            netcdf.close(nc)
            outfile=strcat('..\test\ja2_check\',namelist(nm,13:19),'.dat');% ֻȡ���ں�pass���
            fid2 = fopen(outfile,'w');
            k=0;
            for i=1:length(lon)
                
                ssh=double(alt(i)-r_ku(i))/10000- ...
                double(dry(i)+wet(i)+ino(i)+ssb(i)+inv(i)+hff(i)+set(i)+pt(i))/1E4 - double(ots(i))/1E4;
                sla=double(alt(i)-r_ku(i)-mss(i))/10000- ...
                double(dry(i)+wet(i)+ino(i)+ssb(i)+inv(i)+hff(i)+set(i)+pt(i))/1E4 - double(ots(i))/1E4;
                ssh_i=double(alt(i)-r_ku(i))/10000- ...
                double(dry(i)+wet(i)+ino(i)+ssb(i)+set(i)+olt(i)+pt(i))/1E4;
                % editing criteria given by handbook
                % &&  (ice_f(i)==0)
                % qianliyan ((lat(i))<37000000 &&(lat(i))> 36000000)
                if(((lat(i))<max_lat &&(lat(i))> min_lat) && (surf_t(i)==0)  && (0<=r_rms(i) && r_rms(i)<=2000) ...
                    && ((alt(i)-r_ku(i))>-1300000 && (alt(i)-r_ku(i)) < 1000000) ...
                    && (-25000<=dry(i) && dry(i)<=-19000)&& (-5000<=wet(i)&&wet(i)<=-10)  && (-4000<=ino(i)&&ino(i)<=400)......
                    && (-5000<=ssb(i)&&ssb(i)<=0)...
                    && (-50000<=ots(i)&&ots(i)<=50000) && (-10000<=set(i)&&set(i)<=10000) &&  (-1500<=pt(i)&&pt(i)<=1500) ...
                    && (sig0_rms(i)<=100) && (700<sig(i)&&sig(i)<3000) && (wnd(i)>0 && wnd(i)< 3000) ...
                    && (0<=swh(i)&&swh(i)<=11000) && (-2000<=off_nd_ag(i)&&off_nd_ag(i)<=6400))
     
%                         if (((lat(i))<39000000 &&(lat(i))> 38000000) && ((alt(i)-r_ku(i))>-1300000 && (alt(i)-r_ku(i)) < 1000000))
                        fprintf(fid2,'%12.6f %12.6f %12.6f  %12.6f  %12.8f %12.8f\n',double(lon(i))/1E6,double(lat(i))/1E6,time(i),ssh_i,ssh,sla);
                        fprintf(fid1,'%12.6f %12d\n',double(lat(i))/1E6,nm);
                        k=k+1;% statistic of valid point number 
%                         end

                end
            end
            fclose(fid2);
            fprintf (fid3,'%12s %12d\n',namelist(nm,13:19),k);
        end
%     end
end 
fclose('all');
% % ###############################################
% % draw figure for statistic 
% 
% load ..\test\ja2_check\ponits_circle.txt
% load  ..\test\ja2_check\ponits_number.txt
% 
% latitude=ponits_circle(:,1);
% points=ponits_circle(:,2);
% circle=ponits_number(:,1);
% cir_number=ponits_number(:,2);
% 
% figure(1);
% hold on
% 
% plot(latitude,points,'o')
% xlabel('γ��/��')
% ylabel('��������')
% ylim([min_cir max_cir]);
% % pass 153
% xlim([min_lat/1E6 max_lat/1E6])
% plot ([36.8 36.8],[180 205],'LineWidth',4)
% plot ([36.3 36.3],[180 205],'LineWidth',4)
% text(36.3,205,' \leftarrow ǧ����','FontSize',10)
% text(36.66,205,' ��½ ','FontSize',10)
% 
% for i=1:length(circle)
% text(36.48,circle(i),num2str(cir_number(i)),'FontSize',10)
% end
% 
% hold off
% grid on
% 
% % *************************************************************************
% % ��ͼSSHÿ���ڹ۲�ֵ���Լ���ֵ
% 
% a(1:(max_cir-min_cir+1))=0;% �洢SSH
% fid4=fopen('..\test\ja2_check\statistic.txt','w');
% 
% figure(2);
% hold on
% for i=min_cir:max_cir
% % for i= [200] % ֻ����һ�����ڵ�һ��pass���ݣ�����i [200] ��ʾ200����
% 
%         temp='..\test\ja2_check\';
%         temp1=check_circle(i);% ���ú������ж�circle��λ����
%         temp2=num2str(temp1);
%         temp3=temp2(3:5);% �����λ�����ַ�����
%         tmp=strcat('_',num2str(pass_num));
%         temp4= strcat(temp,temp3,tmp,'.dat');
%         temp5= strcat('X',temp3,tmp);
%     if exist(temp4,'file')
%         load (temp4)
%         temp6=eval(temp5);% �ַ�����������ʹ�ã�temp5��load�����ı�����һ����
%         
%         if size(temp6)~=0
%             latitude=temp6(:,2);
%             points=temp6(:,5);
%             a(i-min_cir+1)=mean(points);% ����SSH��ֵ
% %           b(i-min_cir+1)=std(points);% ����std
%             fprintf(fid4,'%12d %12.6f \n',i,a(i-min_cir+1));% ����
% 
%             plot(latitude,points,'-o')
%             xlabel('γ��/��')
%             ylabel('SSH/m') 
%         end
%     end
% end 
% 
% fclose(fid4);
% 
% xlim([min_lat/1E6 max_lat/1E6])
% % plot ([36.7 36.7],[-500 0],'LineWidth',2)
% % plot ([36.3 36.3],[-500 0],'LineWidth',2)
% % plot ([34.4 34.4],[-500 0],'LineWidth',2)
% % text(36.3,min_y+10,'\leftarrow ǧ����','FontSize',10)
% % text(36.4,min_y+5,'��½\rightarrow ','FontSize',10)
% % text(34.4,min_y+5,'\leftarrow ��½','FontSize',10)
% hold off
% 
% % clear all
% figure (3)
% load ..\test\ja2_check\statistic.txt
% plot(statistic(:,1),statistic(:,2),'-o');
% xlabel('����')
% ylabel('MSSH/mm')
% legend('Mean')

return