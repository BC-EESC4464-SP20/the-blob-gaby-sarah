filename = 'jplMURSST41anommday_b7e9_0580_070c.nc';
ncdisp(filename)
%%
lat_sat = ncread(filename,'latitude');
lon_sat = ncread(filename,'longitude');
%%
time_sat = ncread(filename,'time');
tt_sat=datenum(1970,1,1,0,0,time_sat);
diff_tt_sat=diff(tt_sat)
%%
sstAnom_sat = ncread(filename,'sstAnom');
%%
imagesc(sstAnom_sat(:,:,86))
