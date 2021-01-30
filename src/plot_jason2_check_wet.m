% ###############################################
% draw figure for statistic 
% Jason-2 and Jason-3
function plot_jason2_check_wet(pass_num,min_cir,max_cir,sat)

min_y=0;%Y�᷶Χ�ĳ�ʼֵ���������жϸı��ֵ
max_y=-600;
a(1:(max_cir-min_cir+1))=0;% �洢radio��model�����ֵ
b(1:(max_cir-min_cir+1))=0;% �洢radio��model����std
if sat==1
    fid4=fopen('..\test\ja2_check\statistic.txt','w');
    temp='..\test\ja2_check\';
elseif sat==4
    fid4=fopen('..\test\ja3_check\statistic.txt','w');
    temp='..\test\ja3_check\';
end
% figure(5);
figure('Name','Wet PD along Track for Each Cycle','NumberTitle','off');
hold on

for i=min_cir:max_cir
% for i= [200] % ֻ����һ�����ڵ�һ��pass���ݣ�����i [200] ��ʾ200����
i;
        
        temp1=check_circle(i);% ���ú������ж�circle��λ����
        temp2=num2str(temp1);
        temp3=temp2(3:5);% �����λ�����ַ�����
        t1=check_circle(pass_num);
        t2=num2str(t1);
        t3=t2(3:5);% �����λ�����ַ�����
        tmp=strcat('_',t3);
        temp4= strcat(temp,temp3,tmp,'.txt');
        s=dir(temp4);
    if exist(temp4,'file') && s.bytes~=0
%         temp4;
        temp6=load (temp4);
        latitude=temp6(:,2);
        points=temp6(:,3);
        points_m=temp6(:,4);
        r_m=points-points_m;
        
        a(i-min_cir+1)=mean(points-points_m);% The Wet PD value is nagtive.
        b(i-min_cir+1)=std(points-points_m);% ����std
        fprintf(fid4,'%12d %12.6f %12.6f\n',i,a(i-min_cir+1),b(i-min_cir+1));% ����

        plot(latitude,points,'-o')
%         plot(latitude,r_m,'-o')
%         plot(latitude,points,'-',latitude,points_m,'+-r')
        xlabel('Latitude/��')
        ylabel('Wet troposhere delay from Jason-2 AMR/mm')

        % �ж�Y�������С��Χ
        %radiometer��modelͬ�ж�
        if ((min_y>min(points))|| (min_y>min(points_m)))
            if min(points)>=min(points_m)
                min_y=min(points_m);
            else
                min_y=min(points);
            end
        end
        if (max_y<max(points) || max_y<max(points_m))
            if max(points)>=max(points_m)
                max_y=max(points);
            else
                max_y=max(points_m);
            end
        end
        % radiometer only
    %      if min_y>min(points)
    %          min_y=min(points);
    %      end
    %     if max_y<max(points) 
    %         max_y=max(points);
    %     end
    end
end 
fclose(fid4);
hold off

figure('Name','Wet PD Difference between Radiometer and Model','NumberTitle','off');
if sat==1
    load ..\test\ja2_check\statistic.txt
elseif sat==4
    load ..\test\ja3_check\statistic.txt
end
w_m=statistic(:,2);
% &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
% ���������޳��ֲ�
hehe=std(w_m);% tmpp��ʾ��Ҫ���������ݣ�tttû��ʵ�����á�
hehe2=mean(w_m);
hehe3=hehe2+3*hehe;
hehe4=hehe2-3*hehe;
[n]=find(w_m(:,1)>hehe3);
statistic(n,1)=NaN;
[n]=find(w_m(:,1)<hehe4);
statistic(n)=NaN;
statistic(any(isnan(statistic), 2),:) = [];%��NaN����ȥ��
% &%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if sat==1
    save ..\test\ja2_check\ja2_wet_m_model.txt statistic -ascii
elseif sat==4
    save ..\test\ja3_check\ja3_wet_m_model.txt statistic -ascii
end

plot(statistic(:,1),-statistic(:,2),'-o',statistic(:,1),statistic(:,3),'-ro');

tmpp=-mean (statistic(:,2)); % Be attention the -. Nagetive means shorter.
% The nagetive bias mean the radiometer is shorter.
Q=['mean of radiometer and model wet dely is:', num2str(tmpp)];
disp(Q);

tmpp=mean (statistic(:,3));
Q=['STD of radiometer and model wet dely is:', num2str(tmpp)];
disp(Q);

xlabel('����')
ylabel('�����-Model��ʪ�ӳ�/mm')
legend('Mean','Std')


return