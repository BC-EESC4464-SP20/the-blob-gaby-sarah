%% 1. Explore and extract data from one year of OOI mooring data

% myFolder = 'myFolder';
% filePattern = fullfile (myFolder,'*.nc');
% theFiles = dir(filePattern);

for i=3
baseFileName = theFiles(i).name;
filename=baseFileName

ncdisp(filename)


theFiles(i).lat = ncreadatt(filename,'/','lat');
theFiles(i).lon = ncreadatt(filename,'/','lon');


theFiles(i).time = ncread(filename,'time');
 
theFiles(i).SST = ncread(filename,'ctdmo_seawater_temperature');

theFiles(i).pressure = ncread(filename,'pressure');

theFiles(i).tt=datenum(1900,1,1,0,0,theFiles(i).time);

theFiles(i).difftt= diff(theFiles(i).tt)
end 
%%
plot(theFiles(i).tt, theFiles(i).SST)
hold on
datetick('x', 23)

theFiles(i).minute_diff= (diff(tt)*1440)
theFiles(i).interval=1440/minute_diff(1,1)

theFiles(i).smooth_SST= movmean(SST,interval)
%%
plot(theFiles(i).tt,theFiles(i).smooth_SST, "r-")
datetick('x', 23)

%%
% 4b. Use the movstd function to calculate the 1-day moving standard
% deviation of the data.

theFiles(i).movstd_SST= movstd(theFiles(i).smooth_SST,theFiles(i).interval)

plot(theFiles(i).tt,theFiles(i).movstd_SST, "r-")
datetick('x', 23)


%% 5. Honing your initial investigation plot
% Building on the initial plot you made in #3 above, now add:
%5a. A plot of the 1-day moving mean on the same plot as the original raw data

plot(theFiles(i).tt, theFiles(i).SST)
datetick('x', 23)

hold on 
plot(theFiles(i).tt,theFiles(i).smooth_SST, "r-")
datetick('x', 23)

hold off

%5b. A plot of the 1-day moving standard deviation, on a separate plot
%underneath, but with the same x-axis (hint: you can put two plots in the
%same figure by using "subplot" and you can specify

figure (4);

subplot (2,1,1)
plot(theFiles(i).tt,theFiles(i).movstd_SST, "r-")

subplot (2,1,2)
plot(theFiles(i).tt, theFiles(i).SST)
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
theFiles(i).cut_off=.025
theFiles(i).new_STD= find(theFiles(i).movstd_SST<=theFiles(i).cut_off)

theFiles(i).cut_off_SST= theFiles(i).SST(theFiles(i).new_STD)
theFiles(i).cut_off_tt= theFiles(i).tt(theFiles(i).new_STD)


%6b. Find the indices of the data points that you are not excluding based
%on the cutoff chosen in 6a.

%6c. Update your figure from #5 to add the non-excluded data as a separate
%plotted set of points (i.e. in a new color) along with the other data you
%had already plotted.

%movmean
plot(theFiles(i).tt,theFiles(i).smooth_SST, "k-")
datetick('x', 23)

%cut_off
hold on
plot(theFiles(i).cut_off_tt, theFiles(i).cut_off_SST, "r-")

hold off

%% 7. Apply the approach from steps 1-6 above to extract data from all OOI deployments in years 1-6
% You could do this by writing a for-loop or a function to adapt the code
% you wrote above to something you can apply across all 5 netCDF files
% (note that deployment 002 is missing)


