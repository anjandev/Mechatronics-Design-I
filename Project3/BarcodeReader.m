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

%% Wide and narrow finder

averageWidth = sum(widths) / length(widths);
wideOrNarrow = [];

for i=1:length(widths)
    if widths(i) > averageWidth
        wideOrNarrow(i) = 'w';
    elseif widths(i) < averageWidth
        wideOrNarrow(i) = 'n';
    end
end

%% clasify
beginningOfWide = 1;

for i = 9: 9:length(wideOrNarrow)
    if wideOrNarrow(beginningOfWide:i) == ['n', 'n', 'n', 'w', 'w', 'n', 'w', 'n', 'n']
        s = 'zero ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'wnnwnnnnw')
        s = '1 ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nnwwnnnnw')
        s = '2 ';
    elseif strcmp((beginningOfWide:i), 'wnwwnnnnn')
        s = '3 ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nnnwwnnnw')
        s = '4 ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'wnnwwnnnn')
        s = '5 ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nnwwwnnnn')
        s = '6 '; 
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nnnwnnwnw')
        s = '7 ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'wnnwnnwnn')
        s = '8 ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nnwwnnwnn')
        s = '9 ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'wnnnnwnnw')
        s = 'A ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nnwnnwnnw')
        s = 'B ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'wnwnnwnnn')
        s = 'C ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nnnnwwnnw')
        s = 'D ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'wnnnwwnnn')
        s = 'E ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nnwnwwnnn')
        s = 'F ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nnnnnwwnw')
        s = 'G ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'wnnnnwwnn')
        s = 'H ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nnwnnwwnn')
        s = 'I ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nnnnwwwnn')
        s = 'J ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'wnnnnnnww')
        s = 'K ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nnwnnnnww')
        s = 'L ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'wnwnnnnwn')
        s = 'M ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nnnnwnnww')
        s = 'N ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'wnnnwnnwn')
        s = 'O ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nnwnwnnwn')
        s = 'P ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nnnnnnwww')
        s = 'Q ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'wnnnnnwwn')
        s = 'R ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nnwnnnwwn')
        s = 'S ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nnnnwnwwn')
        s = 'T ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'wwnnnnnnw')
        s = 'U ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nwwnnnnnw')
        s = 'V ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'wwwnnnnnn')
        s = 'W ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nwnnwnnnw')
        s = 'X ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'wwnnwnnnn')
        s = 'Y ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nwwnwnnnn')
        s = 'Z ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nwnnnnwnw')
        s = 'Hyp ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'wwnnnnwnn')
        s = 'Per ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nwwnnnwnn')
        s = 'Space ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nwnwnwnnn')
        s = 'Dollar ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nwnwnnnwn')
        s = 'Slash ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i), 'nwnnnwnwn')
        s = 'Plus ';
    elseif strcmp(wideOrNarrow(beginningOfWide:i),  'nnnwnwnwn')
        s = 'Mod ';
    end
    
    beginningOfWide = beginningOfWide + 9;

    % each character in the barcode picture. 
    Output = [Output s] % add each output character right next to each other. 
end

Output
