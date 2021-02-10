% See https://forum.generic-mapping-tools.org/t/is-this-a-small-bug-in-matlab/1312
clc
clear

oldpath = path; % Add GMT path. The GMT is available from https://github.com/GenericMappingTools/gmt
path(oldpath,'C:\programs\gmt6exe\bin'); % Add GMT path

order='grdmath -R119/124/31/37 -A10000/0/4 -Dl -I2m LDISTG = ../temp/dist_to_gshhg_hn2.nc';
gmt(order); 

order='grdmath -R119/124/31/37 -A10000/0/4 -Dc -I2m LDISTG = ../temp/dist_to_gshhg_hn2.nc';
gmt(order); 
