%Calculate the tide difference between different locations.(One point is
%satellte altimter PCA point, another point is the tide station.)
%The input parameter is the sat and loc. The output is the tide difference
%between PCA and tide station.
function [tg_dif]=nao_dif(sat,loc)

% The `if` and `elseif` programs are not easy to read. I will improve this
% part later.

   if strcmp(loc,'qly') && sat==3
%         if 
            load .\qianliyan_tg_cal\hy2.nao2013
            load .\hy2_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\qly.nao2013
            sat_day=hy2(:,1); %���ڵ�ellipsed day����λ�գ���ʼʱ��2013.1.1 00:00:00������2015.1.1 00:00:00
            sat_tg=hy2(:,2); % Ԥ����ϫtide����λcm
%         end
   elseif strcmp(loc,'bqly') && sat==3
            load ..\test\hy2_check\hy2.nao2015_2021
            load ..\test\hy2_check\pca_ssh.txt;
            load ..\test\qly.nao2015_2021 % same with J3
            disp('loading qianliyan hy2b tide model')
            sat_day=hy2(:,1); %���ڵ�ellipsed day��
            sat_tg=hy2(:,2); % Ԥ����ϫtide����λcm

   elseif strcmp(loc,'qly') && sat==1
            load ..\test\ja2_check\ja2.nao2011_2017 % ע��任�ļ�����Ӧ��ͬ��ʱ��
    %         Here is the tide model From 2011.1.1 to 2017.1.1 covering the 92
    %         to 303 cycles. After 303, Jason-2 changed orbit.Before 92, I have
    %         no tide data.        
            load ..\test\ja2_check\pca_ssh.txt;
            load ..\test\qly.nao2011_2017
%             load .\qianliyan_tg_cal\tg_FES2014.qly_ja2pca_2011_2017
            disp('loading qianliyan ja2 tide model')
            sat_day=ja2(:,1); %���ڵ�ellipsed day����λ�գ���ʼʱ��2013.1.1 00:00:00������2015.1.1 00:00:00
            sat_tg=ja2(:,2); % Ԥ����ϫtide����λcm
%             sat_tg=tg_FES2014(:,2);
%         end

   elseif strcmp(loc,'qly') && sat==2
            load .\qianliyan_tg_cal\saral.nao2011_2017
            load .\saral_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\qly.nao2011_2017
            sat_day=saral(:,1); %���ڵ�ellipsed day����λ�գ���ʼʱ��2013.1.1 00:00:00������2015.1.1 00:00:00
            sat_tg=saral(:,2); % Ԥ����ϫtide����λcm
%         end

    elseif strcmp(loc,'qly') && sat==4
            load ..\test\ja3_check\ja3.nao2015_2021 % jason-3��Jason-2���Թ���һ����ϫԤ���ļ�
            load ..\test\ja3_check\pca_ssh.txt;
            load  ..\test\qly.nao2015_2021 % Input of the model tide at QLY
            % ע��任�ļ�����Ӧ��ͬ��ʱ��,qly.nao2015_2017,qly.nao2013

            sat_day=ja3(:,1); %���ڵ�ellipsed day����λ�գ���ʼʱ��2013.1.1 00:00:00������2015.1.1 00:00:00
            sat_tg=ja3(:,2); % Ԥ����ϫtide����λcm
       
    elseif strcmp(loc,'qly') && sat==5
            load ..\test\s3a_check\s3a.nao2015_2019 % jason-3��Jason-2���Թ���һ����ϫԤ���ļ�
            load ..\test\s3a_check\pca_ssh.txt;
            load ..\test\qly.nao2015_2021 % ע��任�ļ�����Ӧ��ͬ��ʱ��,qly.nao2015_2017
            sat_day=s3a(:,1); %���ڵ�ellipsed day����λ�գ���ʼʱ��2013.1.1 00:00:00������2015.1.1 00:00:00
            sat_tg=s3a(:,2); % Ԥ����ϫtide����λcm
        
   elseif strcmp(loc,'cst') || strcmp(loc,'cst009') && sat==3
%        disp('TBD')
%        if 
            load .\qianliyan_tg_cal\hy2._cst_30km_fes
            load .\hy2_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\tg_FES2014.cst_saralpca_2011_2019;
            sat_day=hy2(:,1)-hy2(1,1); %���ڵ�ellipsed day����λ�գ���ʼʱ��2013.1.1 00:00:00������2015.1.1 00:00:00
            sat_tg=hy2(:,2); % Ԥ����ϫtide����λcm
%         end

    elseif strcmp(loc,'cst') || strcmp(loc,'cst009') && sat==1
            load .\qianliyan_tg_cal\ja2.nao2011_2017 % ע��任�ļ�����Ӧ��ͬ��ʱ��
    %         Here is the tide model From 2011.1.1 to 2017.1.1 covering the 92
    %         to 303 cycles. After 303, Jason-2 changed orbit.Before 92, I have
    %         no tide data.        
            load .\ja2_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\qly.nao2011_2017
            sat_day=ja2(:,1); %���ڵ�ellipsed day����λ�գ���ʼʱ��2013.1.1 00:00:00������2015.1.1 00:00:00
            sat_tg=ja2(:,2); % Ԥ����ϫtide����λcm
        

    elseif strcmp(loc,'cst') || strcmp(loc,'cst009') && sat==2
            load .\qianliyan_tg_cal\saral.cst_2011_2019
            load .\saral_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\cst.cst_2011_2019
            load .\qianliyan_tg_cal\tg_FES2014.cst_saralpca_2011_2019;
%           tg_FES2014.cst_saralpca_2011_2019 is provided by FU yanguang,using the fes2014model.
%           First column is the cst,second is the saral pca model value.
            
            sat_day=saral(:,1); %���ڵ�ellipsed day����λ�գ���ʼʱ��2013.1.1 00:00:00������2015.1.1 00:00:00
%             sat_tg=saral(:,2); % Ԥ����ϫtide����λcm
            sat_tg=tg_FES2014(:,2); % Ԥ����ϫtide����λcm
%         end

    elseif strcmp(loc,'cst') || strcmp(loc,'cst009') && sat==4
            load .\qianliyan_tg_cal\ja3.nao2015_2019 % jason-3��Jason-2���Թ���һ����ϫԤ���ļ�
            load .\ja3_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\qly.nao2015_2019 % Input of the model tide at QLY
            % ע��任�ļ�����Ӧ��ͬ��ʱ��,qly.nao2015_2017,qly.nao2013

            sat_day=ja3(:,1); %���ڵ�ellipsed day����λ�գ���ʼʱ��2013.1.1 00:00:00������2015.1.1 00:00:00
            sat_tg=ja3(:,2); % Ԥ����ϫtide����λcm
%         end
    elseif strcmp(loc,'cst') || strcmp(loc,'cst009') && sat==5
            tide=load ('.\qianliyan_tg_cal\fes_cst_s3a.txt');
            load .\s3a_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\tg_FES2014.cst_saralpca_2011_2019;
            sat_day=tide(:,1)-tide(1,1); %���ڵ�ellipsed day����λ�գ���ʼʱ��2013.1.1 00:00:00������2015.1.1 00:00:00
            sat_tg=tide(:,3); % Ԥ����ϫtide����λcm
%         end
    elseif (strcmp(loc,'zmw') || strcmp(loc,'zmw735') || strcmp(loc,'zmw436')) && sat==1
%        if sat==1
            load ..\test\ja2_check\ja2.nao_zmw_2011_2021_25km % ע��任�ļ�����Ӧ��ͬ��ʱ��
    %         Here is the tide model From 2011.1.1 to 2017.1.1 covering the 92
    %         to 303 cycles. After 303, Jason-2 changed orbit.Before 92, I have
    %         no tide data.
            load ..\test\ja2_check\pca_ssh.txt;
            load ..\test\zmw.nao_2011_2021_
            sat_day=ja2(:,1); %���ڵ�ellipsed day����λ�գ���ʼʱ��2013.1.1 00:00:00������2015.1.1 00:00:00
            sat_tg=ja2(:,2); % Ԥ����ϫtide����λcm
%        end
       elseif sat==2 && strcmp(loc,'zmw735')
            load .\qianliyan_tg_cal\saral.nao_zmw_2011_2019_25km
            load .\saral_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\zmw.nao_2011_2019_
           
            sat_day=saral(:,1); %���ڵ�ellipsed day����λ�գ���ʼʱ��2013.1.1 00:00:00������2015.1.1 00:00:00
            sat_tg=saral(:,2); % Ԥ����ϫtide����λcm
%        end 
       elseif sat==2 && strcmp(loc,'zmw436')
            load .\qianliyan_tg_cal\saral.zmw_saral_436
            load .\saral_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\zmw.nao_2011_2019_
           
            sat_day=saral(:,1); %���ڵ�ellipsed day����λ�գ���ʼʱ��2013.1.1 00:00:00������2015.1.1 00:00:00
            sat_tg=saral(:,2); % Ԥ����ϫtide����λcm
%        end  
      elseif (strcmp(loc,'zmw') || strcmp(loc,'zmw735') || strcmp(loc,'zmw436')) && sat==4
            load ..\test\ja2_check\ja2.nao_zmw_2011_2021_25km % Jason3 is same with Jason-2 at zmw
    %         Here is the tide model From 2011.1.1 to 2017.1.1 covering the 92
    %         to 303 cycles. After 303, Jason-2 changed orbit.Before 92, I have
    %         no tide data.        
            load ..\test\ja3_check\pca_ssh.txt;
            load ..\test\zmw.nao_2011_2021_
            sat_day=ja2(:,1); %���ڵ�ellipsed day����λ�գ���ʼʱ��2013.1.1 00:00:00������2015.1.1 00:00:00
            sat_tg=ja2(:,2); % Ԥ����ϫtide����λcm
%       end 
      elseif (strcmp(loc,'zmw') || strcmp(loc,'zmw735') || strcmp(loc,'zmw436')) && sat==5
            load .\qianliyan_tg_cal\s3a.zmw_s3a_25km % ע��任�ļ�����Ӧ��ͬ��ʱ��
    %         Here is the tide model From 2011.1.1 to 2017.1.1 covering the 92
    %         to 303 cycles. After 303, Jason-2 changed orbit.Before 92, I have
    %         no tide data.        
            load .\s3a_check\pca_ssh.txt;
            load .\qianliyan_tg_cal\zmw.nao_2011_2019_
            sat_day=s3a(:,1); %���ڵ�ellipsed day����λ�գ���ʼʱ��2013.1.1 00:00:00������2015.1.1 00:00:00
            sat_tg=s3a(:,2); % Ԥ����ϫtide����λcm
%       end       
      elseif (strcmp(loc,'zmw') || strcmp(loc,'bzmw')) && sat==3 
            load ..\test\hy2_check\hy2.nao_2011_2021_ % contain time span of 2A (from 2011) and 2B (from 2018) 
            load ..\test\hy2_check\pca_ssh.txt;
            load ..\test\zmw.nao_2011_2021_
            sat_day=hy2(:,1); %
            sat_tg=hy2(:,2); % cm
%       end    
      elseif strcmp(loc,'zhws') && sat==4
%        if
            load ..\test\ja3_check\ja3.nao_zhws %    
            load ..\test\ja3_check\pca_ssh.txt;
            load ..\test\zhws.nao_2019_2022
            sat_day=ja3(:,1); %���ڵ�ellipsed day����λ�գ���ʼʱ��2013.1.1 00:00:00������2015.1.1 00:00:00
            sat_tg=ja3(:,2); % Ԥ����ϫtide����λcm
%        end
      elseif strcmp(loc,'zhws') &&  sat==3
            load ..\test\hy2_check\hy2.nao_zhws % 
            load ..\test\hy2_check\pca_ssh.txt;
            load ..\test\zhiwan.nao_2019_2022
            sat_day=hy2(:,1); %���ڵ�ellipsed day����λ�գ���ʼʱ��2013.1.1 00:00:00������2015.1.1 00:00:00
            sat_tg=hy2(:,2); % Ԥ����ϫtide����λcm
%        end
    end
  
   if strcmp(loc,'qly') || strcmp(loc,'bqly')  % I only use the qly_tg to stand for the tg model value at tg station.
        qly_tg=qly(:,2);% NAO tide
%        qly_tg=tg_FES2014(:,1);
   elseif strcmp(loc,'cst') || strcmp(loc,'cst009')
%        qly_tg=cst(:,2);% NAO tide
         qly_tg=tg_FES2014(:,1);
   elseif strcmp(loc,'zmw') || strcmp(loc,'zmw735') || strcmp(loc,'zmw436') || strcmp(loc,'bzmw')
        qly_tg=zmw(:,2);% NAO tide
%        qly_tg=tg_FES2014(:,1);
   elseif strcmp(loc,'zhws') && sat==4
         qly_tg=zhws(:,2);%
   elseif strcmp(loc,'zhws') && sat==3
        qly_tg=zhiwan(:,2);%
   end
   
   
   
    pca_sec=pca_ssh(:,3);% �����ʱ�̡���λΪs���ο�ʱ��Ϊ2000-01-1 00:00:00
    % �Ѷ������ʱ��תΪellipsed day����TGԤ��ʱ��һ������
%     Transform the time reference of satellite pca time to the NAO
%     ellipsed day. Here should be carefull since the start time of NAO
%     maybe different.

    if sat==1 || sat==2 % unit : day
        pca_day=pca_sec/86400-(datenum('2011-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); % ע��任��ݣ���Ӧ��ͬ��ʱ��  
    elseif sat==5 || sat == 4 && strcmp(loc,'qly') % 
        pca_day=pca_sec/86400-(datenum('2015-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); % ע��任��ݣ���Ӧ��ͬ��ʱ�� 
    elseif sat==3 && strcmp(loc,'bqly')
        pca_day=pca_sec/86400-(datenum('2015-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); % ע��任��ݣ���Ӧ��ͬ��ʱ��         
    elseif sat==3 && strcmp(loc,'bzmw')
        pca_day=pca_sec/86400-(datenum('2011-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); % ע��任��ݣ���Ӧ��ͬ��ʱ��                 
    elseif sat == 4 && strcmp(loc,'zmw') % 
        pca_day=pca_sec/86400-(datenum('2011-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); %    
    elseif sat==3 && strcmp(loc,'qly') || strcmp(loc,'cst009')
        pca_day=pca_sec/86400-(datenum('2013-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); % ע��任��ݣ���Ӧ��ͬ��ʱ�� 
    elseif sat==3 && strcmp(loc,'zmw')
        pca_day=pca_sec/86400-(datenum('2011-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); % ע��任��ݣ���Ӧ��ͬ��ʱ�� 
    elseif sat==4 && strcmp(loc,'zhws') % zhws 2019-01-1 00:00:00
        disp('zhu hai wan shan')
        pca_day=pca_sec/86400-(datenum('2019-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); % 
    elseif sat==3 && strcmp(loc,'zhws') % zhws 2019-01-1 00:00:00
        disp('zhu hai wan shan')
        pca_day=pca_sec/86400-(datenum('2019-01-1 00:00:00')-datenum('2000-01-1 00:00:00')); %         
    end
    
    % *&&&&&*&*&*&*&
    
    % ��ֵ��pca_day��ǧ���ҺͶ����Ԥ����ϫ
%     figure(1234);plot(sat_day(1:2000),sat_tg(1:2000));hold on;plot(sat_day(1:2000),qly_tg(1:2000));hold off
    tg_pca_ssh=interp1(sat_day,sat_tg,pca_day,'PCHIP');
    tg_qly_ssh=interp1(sat_day,qly_tg,pca_day,'PCHIP');
    tg_dif=tg_pca_ssh-tg_qly_ssh;

    % =====================================================================
%     Following lines are to compare the model value with the real tide
%     data. Get the mean difference and the std.
    % =====================================================================
%     if strcmp(loc,'cst') && sat==2
%         disp('HAHAHAHA')
%         filename = 'J:\��ɽͷ�鳱\CST_sort_clean.DD'; 
%         tg=load (filename);
%         %\ǧ���ҳ�ϫ\QLY201301_201412.txt    I:\ǧ���Ҷ��ζ���\qlytg\tg_new_201501_201703.txt tg_new_201501_201712.txt
%         % һ����������ϫ�ļ���ע���滻������ҲҪ�޸Ĳο�ʱ�䡣
% 
%         % Time of tide data 
%         tmp000=tg;
%         tmp1=tmp000(:,1);
%         tmp2=tmp000(:,2);
%         tmp=num2str(tmp1);
%         yyyy=str2num(tmp(:,1:4));
%         mm=str2num(tmp(:,5:6));
%         dd=str2num(tmp(:,7:8));
%         hh=str2num(tmp(:,9:10));
%         ff=str2num(tmp(:,11:12));
%         ss(1:length(ff))=0;
%         ss=ss';
% 
%         date_yj = [yyyy  mm dd hh ff ss];
%         
%         ssh=tmp000(:,2)/100+10.632;
%         t3=((datenum(date_yj)-datenum('2000-01-1 00:00:00'))-8/24);
%         tm2=round(t3*86400);
%         tg_day=tm2/86400-(datenum('2011-01-1 00:00:00')-datenum('2000-01-1 00:00:00'));
%         figure (40)
%         sat_day=round(sat_day*86400);
%         tg_day=round(tg_day*86400);  
%         
%         [t, ra, rb] = intersect(sat_day, tg_day);
%         c=[t qly_tg(ra) ssh(rb)];
%         cc=c;
%         whos
%         
%         dif=cc(:,2)/100-cc(:,3);
%                
%         dif_m=mean(dif)
%         dif_std=std(dif)
%         
%         dif=dif-dif_m; 
%         
%         plot(t,dif)
%         title('td model compared to real measurement(cm)');
% 
%     end
%     if strcmp(loc,'qly') && sat==1
%         disp('qly is loading')
%         filename = 'J:\ǧ���ҳ�ϫ\QLY_2011_2018_clean.txt'; 
%         tg=load (filename);
%         %\ǧ���ҳ�ϫ\QLY201301_201412.txt    I:\ǧ���Ҷ��ζ���\qlytg\tg_new_201501_201703.txt tg_new_201501_201712.txt
%         % һ����������ϫ�ļ���ע���滻������ҲҪ�޸Ĳο�ʱ�䡣
% 
%         % Time of tide data 
%         tmp000=tg;
%         tmp1=tmp000(:,1);
%         tmp2=tmp000(:,2);
%         tmp=num2str(tmp1);
%         yyyy=str2num(tmp(:,1:4));
%         mm=str2num(tmp(:,5:6));
%         dd=str2num(tmp(:,7:8));
%         hh=str2num(tmp(:,9:10));
%         ff=str2num(tmp(:,11:12));
%         ss(1:length(ff))=0;
%         ss=ss';
% 
%         date_yj = [yyyy  mm dd hh ff ss];
%         
%         ssh=tmp000(:,2);
%         t3=((datenum(date_yj)-datenum('2000-01-1 00:00:00'))-8/24);
%         tm2=round(t3*86400);
%         tg_day=tm2/86400-(datenum('2011-01-1 00:00:00')-datenum('2000-01-1 00:00:00'));
%         figure (40)
%         sat_day=round(sat_day*86400);
%         tg_day=round(tg_day*86400);  
%         
%         [t, ra, rb] = intersect(sat_day, tg_day);
%         c=[t qly_tg(ra) ssh(rb)];
%         cc=c;
% %         whos
%         
%         dif=cc(:,2)-cc(:,3);
%                
%         dif_m=mean(dif)
%         dif_std=std(dif)
%         
%         ssh=ssh+dif_m; % real tide
%         dif=dif-dif_m; 
%         
%         plot(t,dif)
%         title('td model compared to real measurement(m)');
%         
%         figure(10)
%         plot(tg_dif);
%         title('td dif of two points at the pca time(cm)');
%         
%         figure(20)
%         plot(sat_day(1:300),sat_tg(1:300),'-');
%         hold on
%         plot(sat_day(1:300),qly_tg(1:300),'--');
% 
%         title('td model at two points:cst and pca (cm)');
%         hold off
%         figure(30)
%         plot(tg_day(1:1000),ssh(1:1000),'--')
%         hold on
%         plot(sat_day(1:1000),qly_tg(1:1000),'-')
%         hold off
% 
%     end
return