clc
clear all
close all

%% Constants

INDEX_TO_START_AT = 3; % REMEMBER NOT 0 INDEXED. MUST BE ODD NUMBER. Change this to inc/dec ingored values at the beginning
SAMPLING_TIME=30e-3;
DATA_COLUMN = 1;

% For moving average
WINDOW_SIZE = 4;

% For find peaks
MinPeakDistance = 50;

%% Parsing Data

MyData = csvread('Datalog-2.txt');
lightDataWithIndices= MyData(INDEX_TO_START_AT:end, DATA_COLUMN);

noIndicesIndex = 1;

% read every second value
%for i=2:2:length(lightDataWithIndices)
% lightDataNoIndices(noIndicesIndex)= lightDataWithIndices(i);
% noIndicesIndex = noIndicesIndex + 1;
%end

% For Test
for i=1:1:length(lightDataWithIndices)-630
 lightDataNoIndices(i)= lightDataWithIndices(i);
end

%% Moving Average

for i=1:1:length(lightDataNoIndices) - (WINDOW_SIZE-1)
    MovingAvg(i) = sum(lightDataNoIndices(i:i+(WINDOW_SIZE-1))) / WINDOW_SIZE;
end

%% Derivative of the data
for i=1:length(MovingAvg)-1
    MyLightVals_avg_der(i) = abs(MovingAvg(i+1) - MovingAvg(i));
end

%% Find peaks and ignore any samples within 50 samples

%before it was MAXPEAKDIST

[pks,locs]= findpeaks(MyLightVals_avg_der,'MinPeakDistance', MinPeakDistance);

% Shift locs over by one because everything while drawing is zero indexed
% IE time=0:SAMPLING_TIME:(length(MovingAvg)-1)*SAMPLING_TIME;
% NOTE: Might cause a bug but since I just get the difference for width,
% I dont think it will
for i=1:length(locs)-1
    locs(i) = locs(i)-1;
end

%% Find the widths between the peaks
for i=1:length(locs)-1
    widths(i) = locs(i+1) - locs(i);
end

% NOTE: WIDTHS ARE NOT IN SAMPLING TIME, THEYRE IN INDEX DIFFERENCES
%% Displaying Data

test=length(MyLightVals_avg_der) 

time=0:SAMPLING_TIME:(length(MovingAvg)-1)*SAMPLING_TIME;
timeNoIndices = 0:SAMPLING_TIME:(length(lightDataNoIndices)-1)*SAMPLING_TIME;
timeDer = 0:SAMPLING_TIME:(length(MyLightVals_avg_der)-1)*SAMPLING_TIME;
timePks = locs*SAMPLING_TIME;

plot(timeNoIndices, lightDataNoIndices)
hold on
plot(time, MovingAvg,'r')
hold on
plot(timeDer, MyLightVals_avg_der,'k') %in green
hold on
plot(timePks,pks,'or') %o is circle, r is red
