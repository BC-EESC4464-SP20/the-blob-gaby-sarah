%% 1. Explore and extract data from one year of OOI mooring data
 
filename = 'deployment0005_GP03FLMB.nc';
%1a. Use the function "ncdisp" to display information about the data contained in this file
ncdisp(filename)

%1b. Use the function "ncreadatt" to extract the latitude and longitude attributes of this dataset
%ncreadatt (filename)
lat_moor = ncreadatt(filename,'/','lat');
lon_moor = ncreadatt(filename,'/','lon');

%1c. Use the function "ncread" to extract the variables "time" and
%"ctdmo_seawater_temperature"
time = ncread(filename,'time');
SST = ncread(filename,'ctdmo_seawater_temperature');

% Extension option: Also extract the variable "pressure" (which, due to the
% increasing pressure underwater, tells us about depth - 1 dbar ~ 1 m
% depth). How deep in the water column was this sensor deployed?
pressure = ncread(filename,'pressure');

%% 2. Converting the timestamp from the raw data to a format you can use
% Use the datenum function to convert the "time" variable you extracted
% into a MATLAB numerical timestamp (Hint: you will need to check the units
% of time from the netCDF file.)
tt=datenum(1900,1,1,0,0,time);

% Checking your work: Use the "datestr" function to check that your
% converted times match the time range listed in the netCDF file's
% attributes for time coverage
datestr(tt(1:5))

% 2b. Calculate the time resolution of the data (i.e. long from one
% measurement to the next) in minutes. Hint: the "diff" function will be
% helpful here.
diff (tt)

%% 3. Make an initial exploration plot to investigate your data
% Make a plot of temperature vs. time, being sure to show each individual
% data point. What do you notice about the seasonal cycle? What about how
% the variability in the data changes over the year?
% Hint: Use the function "datetick" to make the time show up as
% human-readable dates rather than the MATLAB timestamp numbers

plot(tt, SST)
hold on
datetick('x', 23)


%% 4. Dealing with data variability: smoothing and choosing a variability cutoff
% 4a. Use the movmean function to calculate a 1-day (24 hour) moving mean
% to smooth the data. Hint: you will need to use the time period between
% measurements that you calculated in 2b to determine the correct window
% size to use in the calculation.


diff_tt=diff(tt);
interval=1/diff_tt(1,1);

smooth_SST= movmean(SST,interval);

plot(tt,smooth_SST, "r-")
datetick('x', 23)


% 4b. Use the movstd function to calculate the 1-day moving standard
% deviation of the data.

movstd_SST= movstd(SST,interval)

plot(tt,movstd_SST, "r-")
datetick('x', 23)


%% 5. Honing your initial investigation plot
% Building on the initial plot you made in #3 above, now add:
%5a. A plot of the 1-day moving mean on the same plot as the original raw data

plot(tt, SST)
datetick('x', 23)

hold on 
plot(tt,smooth_SST, "r-")
datetick('x', 23)

hold off

%5b. A plot of the 1-day moving standard deviation, on a separate plot
%underneath, but with the same x-axis (hint: you can put two plots in the
%same figure by using "subplot" and you can specify

figure (4);

subplot (2,1,2)
plot(tt,movstd_SST, "r-")

subplot (2,1,1)
plot(tt, SST)
datetick('x', 23)

hold on 
plot(tt,smooth_SST, "r-")
datetick('x', 23)



%% 6. Identifying data to exclude from analysis
% Based on the plot above, you can see that there are time periods when the
% data are highly variable - these are time periods when the raw data won't
% be suitable for use to use in studying the Blob.

%6a. Based on your inspection of the data, select a cutoff value for the
%1-day moving standard deviation beyond which you will exclude the data
%from your analysis. Note that you will need to justify this choice in the
%methods section of your writeup for this lab.
%cut off at .025 STD
cut_off=.025
new_STD= find(movstd_SST<=cut_off)

cut_off_SST= SST(new_STD)
cut_off_tt= tt(new_STD)


%6b. Find the indices of the data points that you are not excluding based
%on the cutoff chosen in 6a.

%6c. Update your figure from #5 to add the non-excluded data as a separate
%plotted set of points (i.e. in a new color) along with the other data you
%had already plotted.

figure(5);
subplot (2,1,2)
plot(tt,movstd_SST, "r-")

subplot (2,1,1)
plot(tt, SST, "b-")
datetick('x', 23)

hold on 
plot(tt,smooth_SST, "m-")
datetick('x', 23)

hold on 
plot(cut_off_tt, cut_off_SST, "c-")

hold off
%% Last Question: 7
%% 1. Explore and extract data from one year of OOI mooring data

myFolder = 'myFolder';
filePattern = fullfile (myFolder,'*.nc');
theFiles = dir(filePattern);

for i=1:5
baseFileName = theFiles(i).name;
filename=baseFileName;

ncdisp(filename);

theFiles(i).lat = ncreadatt(filename,'/','lat');
theFiles(i).lon = ncreadatt(filename,'/','lon');

theFiles(i).time = ncread(filename,'time');
 
theFiles(i).SST = ncread(filename,'ctdmo_seawater_temperature');

theFiles(i).pressure = ncread(filename,'pressure');

theFiles(i).tt=datenum(1900,1,1,0,0,theFiles(i).time);

theFiles(i).diff= diff(theFiles(i).tt);
%% Figure Not needed for final

theFiles(i).diff_tt=diff(theFiles(i).tt);
theFiles(i).interval=1/theFiles(i).diff_tt(1,1);

tt_merged = ([theFiles(1).tt; theFiles(2).tt; theFiles(3).tt; theFiles(4).tt; theFiles(5).tt]);
SST_merged= ([theFiles(1).SST; theFiles(2).SST; theFiles(3).SST; theFiles(4).SST; theFiles(5).SST]);
plot(tt_merged, SST_merged)
datetick('x', 23)
%% Figure Not needed for final

theFiles(i).smooth_SST= movmean(theFiles(i).SST,theFiles(i).interval);

smooth_SST_merged= ([theFiles(1).smooth_SST; theFiles(2).smooth_SST; theFiles(3).smooth_SST; theFiles(4).smooth_SST; theFiles(5).smooth_SST]);

plot(tt_merged,smooth_SST_merged, "r.")
datetick('x', 23)

%% Figure Not needed for final
% 4b. Use the movstd function to calculate the 1-day moving standard
% deviation of the data.

theFiles(i).movstd_SST= movstd(theFiles(i).SST,theFiles(i).interval);

movstd_SST_merged = ([theFiles(1).movstd_SST; theFiles(2).movstd_SST; theFiles(3).movstd_SST; theFiles(4).movstd_SST; theFiles(5).movstd_SST]);

plot(tt_merged,movstd_SST_merged, "r.")
datetick('x', 23)
%% Figure Not Needed for Final 
% A plot of the 1-day moving mean on the same plot as the original raw data

plot(tt_merged, SST_merged)
datetick('x', 23)

hold on 
plot(tt_merged,smooth_SST_merged, "r.")
datetick('x', 23)
hold off
%% Figure Needed for Final 
%5b. A plot of the 1-day moving standard deviation, on a separate plot
%underneath, but with the same x-axis (hint: you can put two plots in the
%same figure by using "subplot" and you can specify

figure (1);

subplot (2,1,2)
plot(tt_merged,movstd_SST_merged, "r.")
datetick('x', 23)

subplot (2,1,1)
plot(tt_merged, SST_merged)
datetick('x', 23)

hold on 
plot(tt_merged,smooth_SST_merged, "r.")
datetick('x', 23)
hold off



%% 6. Identifying data to exclude from analysis
% Based on the plot above, you can see that there are time periods when the
% data are highly variable - these are time periods when the raw data won't
% be suitable for use to use in studying the Blob.

%6a. Based on your inspection of the data, select a cutoff value for the
%1-day moving standard deviation beyond which you will exclude the data
%from your analysis. Note that you will need to justify this choice in the
%methods section of your writeup for this lab.
%cut off at .025 STD
theFiles(i).cut_off=.025
theFiles(i).new_STD= find(theFiles(i).movstd_SST<=theFiles(i).cut_off);

theFiles(i).cut_off_SST= theFiles(i).SST(theFiles(i).new_STD);
theFiles(i).cut_off_tt= theFiles(i).tt(theFiles(i).new_STD);

cut_tt_merge=([theFiles(1).cut_off_tt; theFiles(2).cut_off_tt; theFiles(3).cut_off_tt; theFiles(4).cut_off_tt; theFiles(5).cut_off_tt]);
cut_SST_merge=([theFiles(1).cut_off_SST; theFiles(2).cut_off_SST; theFiles(3).cut_off_SST; theFiles(4).cut_off_SST; theFiles(5).cut_off_SST]);
%% Needed for final
%6c. Update your figure from #5 to add the non-excluded data as a separate
%plotted set of points (i.e. in a new color) along with the other data you
%had already plotted.

figure(2);

subplot (2,1,2)
plot(tt_merged,movstd_SST_merged, "b.")
datetick('x', 23)

subplot (2,1,1)
plot(tt_merged, SST_merged, "k.")
datetick('x', 23)

hold on 
plot(tt_merged,smooth_SST_merged, "m.")
datetick('x', 23)

hold on
plot(cut_tt_merge, cut_SST_merge, "c.")

hold off
end

%% Loading Satelite
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
