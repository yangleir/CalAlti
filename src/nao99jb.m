% call NAO99jb Fortran

%% 
function [tide_nao]=nao99jb(lat_t,lon_t,sec)

disp('===========================NAO99jb computing===========================')
cd ../tide

%% ��ȡ�ļ����޸�
fileID = fopen('naotestj.f','r+');                    %�Կɶ�д�ķ�ʽ�򿪴��޸ĵ��ļ�
i=0;

formatOut = 'yyyy/mm/dd HH:MM:SS';
t=datestr(sec/86400+datenum('2000-1-1 00:00:00'),formatOut);
disp(t);
year=t(1:4);
m=t(6:7);
d=t(9:10);
h=t(12:13);
m=t(15:16);

x=strcat('      x       = ',num2str(lon_t),'     ! East longitude in degree');
y=strcat('      y       = ',num2str(lat_t),'     ! North latitude in degree');
iyear1=strcat('      iyear1  = ',year,' ! year');
imon1=strcat('      imon1  = ',m,' ! month');
iday1=strcat('      iday1  = ',d,' ! iday1');
ihour1=strcat('      ihour1  = ',h,' ! ihour1');
imin1=strcat('      imin1  = ',m,' ! imin1');

iyear2=strcat('      iyear2  = ',year,' ! year');
imon2=strcat('      imon2  = ',m,' ! month');
iday2=strcat('      iday2  = ',d,' ! iday1');
ihour2=strcat('      ihour2  = ',h,' ! ihour1');
imin2=strcat('      imin2  = ',m,' ! imin1');


while ~feof(fileID)
        tline=fgetl(fileID);                              %���ж�ȡԭʼ�ļ�
        i=i+1;
        newline{i} = tline;                               %�����¶������ԭʼ�ļ�ÿ������
        if i==27                                        %�ж��Ƿ񵽴���޸ĵ���
            newline{i} = strrep(tline,tline,x);%�滻�����������޸ĵ���ȫ���滻Ϊ������
        end
        if i==28                                        %�ж��Ƿ񵽴���޸ĵ���
            newline{i} = strrep(tline,tline,y);%�滻�����������޸ĵ���ȫ���滻Ϊ������
        end

        if i==31                                        %�ж��Ƿ񵽴���޸ĵ���
            newline{i} = strrep(tline,tline,iyear1);%�滻�����������޸ĵ���ȫ���滻Ϊ������
        end
        if i==32                                        %�ж��Ƿ񵽴���޸ĵ���
            newline{i} = strrep(tline,tline,imon1);%�滻�����������޸ĵ���ȫ���滻Ϊ������
        end
        if i==33                                        %�ж��Ƿ񵽴���޸ĵ���
            newline{i} = strrep(tline,tline,iday1);%�滻�����������޸ĵ���ȫ���滻Ϊ������
        end
        if i==34                                        %�ж��Ƿ񵽴���޸ĵ���
            newline{i} = strrep(tline,tline,ihour1);%�滻�����������޸ĵ���ȫ���滻Ϊ������
        end
        if i==35                                        %�ж��Ƿ񵽴���޸ĵ���
            newline{i} = strrep(tline,tline,imin1);%�滻�����������޸ĵ���ȫ���滻Ϊ������
        end        

        if i==38                                        %�ж��Ƿ񵽴���޸ĵ���
            newline{i} = strrep(tline,tline,iyear2);%�滻�����������޸ĵ���ȫ���滻Ϊ������
        end
        if i==39                                        %�ж��Ƿ񵽴���޸ĵ���
            newline{i} = strrep(tline,tline,imon2);%�滻�����������޸ĵ���ȫ���滻Ϊ������
        end
        if i==40                                        %�ж��Ƿ񵽴���޸ĵ���
            newline{i} = strrep(tline,tline,iday2);%�滻�����������޸ĵ���ȫ���滻Ϊ������
        end
        if i==41                                        %�ж��Ƿ񵽴���޸ĵ���
            newline{i} = strrep(tline,tline,ihour2);%�滻�����������޸ĵ���ȫ���滻Ϊ������
        end
        if i==42                                        %�ж��Ƿ񵽴���޸ĵ���
            newline{i} = strrep(tline,tline,imin2);%�滻�����������޸ĵ���ȫ���滻Ϊ������
        end         
end
fclose(fileID);                                       %�ر��ļ�
    
%% ����ı�
    fileID = fopen('nao.f','w+');                    %�Կɶ�д�ķ�ʽ������ļ����ļ�������������ļ����ݴ��ļ�ͷ����ʼд����������������ļ����������ļ���ֻд��
    for k=1:i
        fprintf(fileID,'%s\t\n',newline{k});              %��newline�ڵ���������д��
    end
    fclose(fileID);                                       %�ر��ļ�
    
%% run fortran
cmd1 = 'gfortran nao.f -o nao';
cmd2 = '.\nao.exe';
[status1, cmdout1] = system(cmd1);
[status2, cmdout2] = system(cmd2);
%%
fileID = fopen('naotestj.out','r');                    %�Կɶ�д�ķ�ʽ�򿪴��޸ĵ��ļ�

while ~feof(fileID)
        tline=fgetl(fileID);                              %���ж�ȡԭʼ�ļ�
end

fclose(fileID);                                       %�ر��ļ�
tide_nao=str2double(tline(15:23));
cd ../src
return
