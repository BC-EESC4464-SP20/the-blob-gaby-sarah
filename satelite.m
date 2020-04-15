filename = 'jplMURSST41anommday_b7e9_0580_070c.nc';
ncdisp(filename)
%%
lat_sat = ncread(filename,'latitude');
lon_sat = ncread(filename,'longitude');
%%
time = ncread(filename,'time');
tt=datenum(1970,1,1,0,0,time);
diff_tt=diff(tt)
%%
sstAnom = ncread(filename,'sstAnom');
%%
imagesc(sstAnom(:,:,86))
%