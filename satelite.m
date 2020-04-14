filename = 'jplMURSST41anommday_f3ed_30ae_1893.nc';
ncdisp(filename)
%%
lat = ncread(filename,'latitude');
lon = ncread(filename,'longitude');
%%
time = ncread(filename,'time');
tt=datenum(1970,1,1,0,0,time);
diff(tt)
%%
sstAnom = ncread(filename,'sstAnom');
%%
imagesc(sstAnom,1581811200,balance)