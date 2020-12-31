% This Fuction  aims to calculate SSH of Tide Gauge at the PCA time of
% satellite altimetry. Then the bias of SA could be easily estimated by
% make SSH difference between tide gauge and SA (after adding corrections) 
% The SA time unit is second, and the reference time for SA is 2000-1-1
% 00:00:00.
% The tide gauge data is provided from China Oceanic Information Network.
% Here the QianLiYan TG data is the input data, which spans from
% 2011-2018. 
% The output of the tide model of NAO, a fortran program, is used here for
% correcting tide difference between different location. 

% This program is wrote by YangLei at FIO,MNR of China.

% Basic steps:
% 1,Read TG data
% 2,Read PCA time of the satellite altimter (unit s, refer to 2000-1-1 00:00:00)
% 3,Determine the SSH of tide gauge station at the PCA time.(interpolate)
% 4,Read tide correction from NAO model.
% 5,Save result.

function [bias2]=tg_pca_ssh(sat,fre,loc)
    if strcmp(loc,'cst') || strcmp(loc,'cst009')
        disp('cst')
        filename = 'J:\��ɽͷ�鳱\CST_sort_clean.DD'; 
    elseif strcmp(loc,'qly') || strcmp(loc,'bqly') % bqly for HY-2B
        disp('qly')
        filename = '..\tg_xinxizx\qly\QLY_2011_2018_clean.txt';
    elseif strcmp(loc,'zmw735') || strcmp(loc,'zmw436') || strcmp(loc,'zmw') || strcmp(loc,'bzmw')|| strcmp(loc,'bzmw2')
        filename = '..\tg_xinxizx\zmw\ZMW_sort_clean.DD';
    elseif strcmp(loc,'zhws') && sat==4
        disp('zhws')
        filename = '..\tide_zhws\tideWailingdingWharf.DD';
    elseif strcmp(loc,'zhws')  && sat==3
        disp('zhws')
        filename = '..\tide_zhws\tideZhiwanWharf.DD';
    else 
        disp("error in loading tide gauge data")        
    end
    
    disp(['loading TG file:',filename])
    disp('loading........................................................')
    tg=load (filename);
%     figure(1000);plot(tg(:,3))
    % give time from tide gauge data
    if strcmp(loc,'qly') || strcmp(loc,'zmw') || strcmp(loc,'bzmw')|| strcmp(loc,'bqly') || strcmp(loc,'bzmw2') % unit is cm
        tmp000=tg;
        tmp1=tmp000(:,1); %yyyymmddHHMM
        tmp=num2str(tmp1);
        yyyy=str2num(tmp(:,1:4));
        mm=str2num(tmp(:,5:6));
        dd=str2num(tmp(:,7:8));
        hh=str2num(tmp(:,9:10));
        ff=str2num(tmp(:,11:12));
        ss(1:length(ff))=0;
        ss=ss';
    elseif strcmp(loc,'zhws') % unit is m
        tmp000=tg;
        tmp1=tmp000(:,1);% yyyymmdd
        tmp2=tmp000(:,2);% hhmmss
        tmp=num2str(tmp1);
        yyyy=str2num(tmp(:,1:4));
        mm=str2num(tmp(:,5:6));
        dd=str2num(tmp(:,7:8));
        tmp=num2str(tmp2);
        hh=floor(tmp2/10000);
        ff=floor((tmp2-hh*1E4)/100);
        ss=tmp2-hh*1E4-ff*1E2;
    end
    
    date_yj = [yyyy  mm dd hh ff ss];
    disp('Finish loading of real TG data')
    
    if strcmp(loc,'qly') || strcmp(loc,'bqly')        
        ssh=tmp000(:,2)/100+7.502;% 7.502 is the parameter of height reference 
    % transform from TG local to WGS-84.
    elseif strcmp(loc,'cst') || strcmp(loc,'cst009')
        ssh=tmp000(:,2)/100+10.632;% 10.632 is the parameter of height reference 
    % transform from TG local to WGS-84.
    elseif strcmp(loc,'zmw') || strcmp(loc,'zmw735') ||  strcmp(loc,'zmw436') || strcmp(loc,'bzmw')|| strcmp(loc,'bzmw2')
        ssh=tmp000(:,2)/100-0.108;% 0.108 is the parameter of height reference 
    % transform from TG local to WGS-84. TBD
    elseif strcmp(loc,'zhws') && sat==4
        ssh=tmp000(:,3)+ 2.7497;% The transform parameter is from the data provider
    elseif strcmp(loc,'zhws') && sat==3 % Location is different for Jason and HY-2 at Wanshan.
        ssh=tmp000(:,3)+ 3.2373;% The transform parameter is from the data provider
    else 
        disp("error in datum uniform")
    end
    
    t3=((datenum(date_yj)-datenum('2000-01-1 00:00:00'))-8/24);%ʱ���ʽת�����ǵĲο�ʱ����2000-01-1 00:00:00��
    % The time zone of TG in China is Zone 8, Thus 8 hours should be
    % subtracted from TG data.
    tm2=round(t3*86400);% This is the time (seconds) of the tide gauge data ��UTC+0 (same with altimeter)
    disp('Finish time reference transform of real TG data')
    
%     % The zhws tide gauge data has the misorder. 
%     if  strcmp(loc,'zhws') && sat==3
%         tmppp=[tm2 ssh];
%         tmpp=sort(tmppp,1); % For
%         tm2=tmpp(:,1);
%         ssh=tmpp(:,2);
%     end
    
    % Load the PCA of satellite altimeter data. Format is : lat lon second
    % ssh cycle
    if sat==1
            load ..\test\ja2_check\pca_ssh.txt;
		elseif sat==2
            load .\saral_check\pca_ssh.txt;
        elseif sat==3
            load ..\test\hy2_check\pca_ssh.txt;
		elseif sat==4
			load ..\test\ja3_check\pca_ssh.txt;
        elseif sat==5
            load ..\test\s3a_check\pca_ssh.txt;
    end
	
    
	pca_tim=round(pca_ssh(:,3));% This is time of SA, as Jason-2&3,etc,.
    ssh_ali=pca_ssh(:,4); % SSH of SA
    cy=pca_ssh(:,5);% cycle
    b=length(ssh_ali); % SA len, the number of SA cycles
    c=length(ff); % TG len
    
    tmp3(1:b)=0; % zero Array, save location of the time of PCA points 
    tmp3=tmp3';
    
    % Loop to find the TG data before and after SA passing over. The data interval for SA is 1 sec and for TG is 10 min.
    % For zhws, the time sample is not uniform.WailingdingWharf is 30
    % seconds,ZhiwanWharf is 4 minutes,DanganWharf is 30 seconds. Actually,
    % there is no need for such high frequency. 10 minute sample is enouth.
    
    for i=1:b
        n=0;
        for j=1:c-1
            
            if((pca_tim(i)<tm2(j+1)) && (pca_tim(i)>tm2(j)) && (abs((pca_tim(i)-tm2(j)))<5000) && (abs((pca_tim(i)-tm2(j+1)))<5000)  || (pca_tim(i)==tm2(j)))
            % Be sure that the tide gauge have valid data before and after
            % 1hour of SA passing. This will detect the tide gauge data
            % gap.
                n=j;
%                 break
                continue
            end

        end
        % ע�� ��ϫ���ݵ���Ч�Լ��顣9998,9989����Чֵ��		
        tmp3(i)=n;% Save the location of PCA time (sec) in TG data �洢�鳱���ݶ�Ӧʱ���λ��
    end
    disp('Finish time selection of TG based on PCA time')
    
    % ��������ϣ��������ʱ�̵�TG��SSH
    tg_pca_ssh(1:b)=-9999;% ����TG��PCA SSHֵ
    if strcmp(loc,'qly') || strcmp(loc,'zmw')
        len_tg=12; % means 120minute=2hour
    elseif strcmp(loc,'bqly') || strcmp(loc,'bzmw')|| strcmp(loc,'bzmw2')
         len_tg=24; % means 120minute=2hour; The tide gauge time interval is changed to 5 min for HY-2B time
    elseif strcmp(loc,'zhws') && sat==4
        len_tg=120/0.5; % data sample is 30 seconds. `120/0.5` = 2 hour
    elseif strcmp(loc,'zhws') && sat==3
        len_tg=20; % data sample is 4(6) min. 
    else 
        disp("error in determine tige gauge time width")
    end
    
    for i=1:b
        if tmp3(i)~=0 
            cy(i)
            loct=tmp3(i); % location in matrix
            ssh_tg2=ssh(loct-len_tg:loct+len_tg); % TG ��ȡ�鳱վ��һʱ��ǰ���2Сʱ�����ݣ���ǰ���12�����ݡ�
            ssh_tg3=smooth(ssh_tg2,4,'rlowess'); % Here should be carefull 
            % to set the smooth algrithm. Also the data length involved.
            tt=tm2(loct-len_tg:loct+len_tg); % TG time
            t_pca=pca_tim(i);% SA
            tg_pca_ssh(i)=interp1(tt,ssh_tg3,t_pca,'PCHIP');
%             figure(23);plot(tt,ssh_tg3,tt,ssh_tg2);
        end
    end
    
    disp('Finish interpolation of TG SSH at PCA')
    % test interp and smooth
    % plot(tt,ssh_tg2,'-bo',tt,ssh_tg3,'-rs',t_pca,tg_pca_ssh(b),'bs','MarkerSize',10)
    
    % �������ƫ��
    
    % First, the DTU MSS model is used to get the MSS value at the PCA
    % points. This step was done by the GMT track program and data was
    % saved in the *.dat file. Then, the *.dat file will be read in the
    % follwing codes. Be carefull that length of *.dat is based on the input
    % file of pca_ssh.txt. In the *.dat file, the first line is the MSS at
    % the TG points, and the left lines are corresponding to the PCA
    % points. Thus, make the subtraction and get the MSS correction. 
    if strcmp(loc,'qly') || strcmp(loc,'bqly')
        if sat==1
            mss=load ('..\test\ja2_check\dtu18_qly.dat');
            jason2_mss=mss;
            tg_mss=jason2_mss(1,3);
            jason_mss=jason2_mss(2:length(jason2_mss),3);
            mss_correction=-(jason_mss-tg_mss); % this is the needed parameter.

        elseif ((sat==2) && (fre==40))

            mss=load ('.\qianliyan_tg_cal\saral40_qly.dat');
            tg_mss=mss(1,3);
            saral_mss=mss(2:length(mss),3);
            mss_correction=-(saral_mss-tg_mss);

        elseif ((sat==2) && (fre==1))

            mss=load ('.\qianliyan_tg_cal\saral_all_dtu18.dat'); % ע���滻dat�ļ���
            saral_m=mss;
            tg_mss=saral_m(1,3);
            saral_mss=saral_m(2:length(saral_m),3);
            mss_correction=-(saral_mss-tg_mss);

        elseif ((sat==3) && (fre==1))

            hy2=load ('..\test\hy2_check\dtu18.dat');
            hy2_mss=hy2;
            tg_mss=hy2_mss(1,3);
            hy_mss=hy2_mss(2:length(hy2_mss),3);
            mss_correction=-(hy_mss-tg_mss);            

        elseif sat==4
            ja3 = load ('..\test\ja3_check\dtu18_qly.dat');% Ja3.
            jason3_mss=ja3;
            tg_mss=jason3_mss(1,3);
            jason_mss=jason3_mss(2:length(jason3_mss),3);
            mss_correction=-(jason_mss-tg_mss);

        elseif sat==5
            mss=load ('..\test\s3a_check\dtu18_qly.dat');% ע���滻��jason-2.dat�Ƕ�Ӧ��2013-2014��jason2_2011�Ƕ�Ӧ��2011-2012.
            s3a_mss=mss;
            tg_mss=s3a_mss(1,3);
            s3a_mss=s3a_mss(2:length(s3a_mss),3);
            mss_correction=-(s3a_mss-tg_mss);
        end
        
    elseif strcmp(loc,'cst') || strcmp(loc,'cst009')
        if sat==1
            mss=load ('.\qianliyan_tg_cal\jason2_2011_2017_dtu18.dat');
            jason2_mss=mss;
            tg_mss=jason2_mss(1,3);
            jason_mss=jason2_mss(2:length(jason2_mss),3);
            mss_correction=-(jason_mss-tg_mss); % this is the needed parameter.

        elseif ((sat==2) && (fre==40))

            load .\qianliyan_tg_cal\saral40.dat;
            tg_mss=saral40(1,3);
            saral_mss=saral40(2:length(saral40),3);
            mss_correction=-(saral_mss-tg_mss);

        elseif ((sat==2) && (fre==1))

            mss=load ('.\qianliyan_tg_cal\saral_all_dtu18_cst.dat'); % ע���滻dat�ļ���
            saral_m=mss;
            tg_mss=saral_m(1,3);
            saral_mss=saral_m(2:length(saral_m),3);
            mss_correction=-(saral_mss-tg_mss);

        elseif ((sat==3) && (fre==1))

            hy2=load ('.\qianliyan_tg_cal\hy2_cst_dtu18.dat');
            tg_mss=hy2(1,3);
            saral_mss=hy2(2:length(hy2),3);
            mss_correction=-(saral_mss-tg_mss);

        elseif sat==4
            ja3 = load ('.\qianliyan_tg_cal\jason3_2016_2018_dtu18.dat');% Ja3.
            jason3_mss=ja3;
            tg_mss=jason3_mss(1,3);
            jason_mss=jason3_mss(2:length(jason3_mss),3);
            mss_correction=-(jason_mss-tg_mss);

        elseif sat==5
            mss=load ('.\qianliyan_tg_cal\s3a_2019_dtu18_cst.dat');% ע���滻��jason-2.dat�Ƕ�Ӧ��2013-2014��jason2_2011�Ƕ�Ӧ��2011-2012.
            s3a_mss=mss;
            tg_mss=s3a_mss(1,3);
            s3a_mss=s3a_mss(2:length(s3a_mss),3);
            mss_correction=-(s3a_mss-tg_mss);
        end
    elseif strcmp(loc,'zmw') || strcmp(loc,'zmw735') || strcmp(loc,'zmw436') || strcmp(loc,'bzmw')|| strcmp(loc,'bzmw2')
        if sat==1
            mss=load ('..\test\ja2_check\dtu18_qly.dat');
            jason2_mss=mss;
            tg_mss=jason2_mss(1,3);
            jason_mss=jason2_mss(2:length(jason2_mss),3);
            mss_correction=-(jason_mss-tg_mss); % this is the needed parameter.

        elseif ((sat==2) && (fre==40))

            mss=load ('.\qianliyan_tg_cal\saral_all_dtu18_zmw735.dat');
            tg_mss=mss(1,3);
            saral_mss=mss(2:length(mss),3);
            mss_correction=-(saral_mss-tg_mss);

        elseif ((sat==2) && (fre==1))

            mss=load ('.\qianliyan_tg_cal\saral_all_dtu18_zmw735.dat'); % ע���滻dat�ļ���
            saral_m=mss;
            tg_mss=saral_m(1,3);
            saral_mss=saral_m(2:length(saral_m),3);
            mss_correction=-(saral_mss-tg_mss);

        elseif ((sat==3) && (fre==1))

            hy2=load ('..\test\hy2_check\dtu18.dat');
            tg_mss=hy2(1,3);
            saral_mss=hy2(2:length(hy2),3);
            mss_correction=-(saral_mss-tg_mss);

        elseif sat==4
            ja3 = load ('..\test\ja3_check\dtu18_qly.dat');% Ja3.
            jason3_mss=ja3;
            tg_mss=jason3_mss(1,3);
            jason_mss=jason3_mss(2:length(jason3_mss),3);
            mss_correction=-(jason_mss-tg_mss);

        elseif sat==5
            mss=load ('.\qianliyan_tg_cal\s3a_2019_dtu18_zmw.dat');% ע���滻��jason-2.dat�Ƕ�Ӧ��2013-2014��jason2_2011�Ƕ�Ӧ��2011-2012.
            s3a_mss=mss;
            tg_mss=s3a_mss(1,3);
            s3a_mss=s3a_mss(2:length(s3a_mss),3);
            mss_correction=-(s3a_mss-tg_mss);
        end
     elseif strcmp(loc,'zhws') 
           if sat==4
                ja3 = load ('..\test\ja3_check\dtu18_zhws.dat');% Ja3.
                jason3_mss=ja3;
                tg_mss=jason3_mss(1,3);
                jason_mss=jason3_mss(2:length(jason3_mss),3);
                mss_correction=-(jason_mss-tg_mss);% cm
           elseif sat==3
                ja3 = load ('..\test\hy2_check\dtu18_zhws.dat');% Ja3.
                jason3_mss=ja3;
                tg_mss=jason3_mss(1,3);
                jason_mss=jason3_mss(2:length(jason3_mss),3);
                mss_correction=-(jason_mss-tg_mss);% cm
           end
    end 
    disp(['Finish DTU MSS correction,MEAN (cm):',num2str(mean(mss_correction))])

    disp('Begin NAO file loading and correction')  
%         =================================================================
%         plot(mss_correction,'-o'); % look at this figure, a repeat cycle
%         is very clear, which means the orbit of SA is controled by
%         something.

%         plot(pca_ssh(:,1)); % latitude or longitude of SA movements in a
%         repeated cycle.  
%         =================================================================

%         bias(1:length(ssh_ali))=0;
%     for i=1:length(ssh_ali)
%         bias(i)=ssh_ali(i)-tg_pca_ssh(i)-0.7179+mss_correction(i);
%     end
%     
%     tg_pca_ssh2=tg_pca_ssh';

    [tg_dif]=nao_dif(sat,loc);% ��ϫ����

    mean_tg_dif=mean(tg_dif);
    
    disp(['mean_tg_dif(cm):',num2str(mean_tg_dif)]);
    disp('Finish NAO file loading and correction') 
    disp('Begain calculate the bias of SA by adding NAO and MSS correction')
%     disp('The parameters size are:')
%     whos
    
    if strcmp(loc,'zhws') % the reference ellipsoid height difference between WGS and TP. BY wgs_tp.m
        wgs_tp=0.699917949844327;
    elseif strcmp(loc,'bqly') || strcmp(loc,'qly') || strcmp(loc,'zmw')|| strcmp(loc,'bzmw') || strcmp(loc,'bzmw2') % for zmw and qly this value is very close.
        wgs_tp=0.7179;        
    end
%     whos
    
    if sat==5
        bias=ssh_ali-(tg_pca_ssh')+mss_correction-tg_dif/100;
%       Sentinel-3 height reference is WGS-84,which is not the same with
%       other SA missions. The unit of bias is m
    else
        bias=ssh_ali-(tg_pca_ssh')-wgs_tp+mss_correction-tg_dif/100; 
%         Height reference for other SA missions is T/P which has a 0.7179m
%         transtorm difference with WGS-84 (TG reference). This value could
%         be calculated by program wgs_tp.m.
    end

    disp('Finish bias calculation')
    
    tmpp=bias; % bias unit m
    ttt=pca_ssh(:,5); % cycle number
    tim2=pca_ssh(:,3); % time in seconds
    
%     [tmpp,ttt]=three_sigma_delete(tmpp,ttt);
    bias2=[ttt tmpp tim2];
%     save_data=[ssh_ali tg_pca_ssh2 mss_correction bias];
%     save jason_2_bias_new_all.txt save_data -ASCII % ����������

return