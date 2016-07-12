clc
clear all
close all

%% Constants

INDEX_TO_START_AT = 3; % REMEMBER NOT 0 INDEXED. MUST BE ODD NUMBER. Change this to inc/dec ingored values at the beginning
SAMPLING_TIME=30e-3;
DATA_COLUMN = 1;

% For moving average
WINDOW_SIZE = 22;

% For find peaks
MinPeakDistance = 40;
MinPeakHeight = 0.8;
IGNORE_FIRST = 8;

%% Parsing Data

MyData = csvread('datalog-2.txt');
lightDataWithIndices= MyData(INDEX_TO_START_AT:end, DATA_COLUMN);

noIndicesIndex = 1;

% read every second value
for i=IGNORE_FIRST:2:length(lightDataWithIndices)
 lightDataNoIndices(noIndicesIndex)= lightDataWithIndices(i);
 noIndicesIndex = noIndicesIndex + 1;
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

[pks,locs]= findpeaks(MyLightVals_avg_der,'MinPeakDistance', MinPeakDistance, 'MinPeakHeight', MinPeakHeight);

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

time=0:SAMPLING_TIME:(length(MovingAvg)-1)*SAMPLING_TIME;
timeNoIndices = 0:SAMPLING_TIME:(length(lightDataNoIndices)-1)*SAMPLING_TIME;
timeDer = 0:SAMPLING_TIME:(length(MyLightVals_avg_der)-1)*SAMPLING_TIME;
timePks = locs*SAMPLING_TIME;

subplot(2,1,1)
plot(timeNoIndices, lightDataNoIndices)
hold on
plot(time, MovingAvg,'r')
hold on
subplot(2,1,2)
plot(timeDer, MyLightVals_avg_der,'k') %in green derivative
hold on
plot(timePks,pks,'or') %o is circle, r is red % show peaks

%% Wide and narrow finder

averageWidth = ((max(widths) + min(widths)) / 2)-10;
%averageWidth = 180;
wideOrNarrow = [];

for i=1:length(widths)
    if widths(i) > averageWidth
        wideOrNarrow(i) = 'w';
    elseif widths(i) < averageWidth
        wideOrNarrow(i) = 'n';
    end
end


%% Clasify
beginningOfWide = 1;
outputIndex = 1;
Letters = [];


for i = 1:9:length(wideOrNarrow)
    if i+8+(outputIndex -1) <= length(wideOrNarrow)
        Letter = wideOrNarrow(i + (outputIndex -1):i+8+(outputIndex -1));
    else
        break
    end 
    
    
    if Letter == ['n', 'n', 'n', 'w', 'w', 'n', 'w', 'n', 'n'];
        s = '0'
          
    elseif Letter == ['w', 'n', 'n', 'w', 'n', 'n', 'n', 'n', 'w'];
        s = '1'
          
    elseif Letter == ['n', 'n', 'w', 'w', 'n', 'n', 'n', 'n', 'w'];
        s = '2'
          
    elseif Letter == ['w', 'n', 'w', 'w', 'n', 'n', 'n', 'n', 'n'];
        s = '3'
          
    elseif Letter == ['n', 'n', 'n', 'w', 'w', 'n', 'n', 'n', 'w'];
        s = '4'
          
    elseif Letter == ['w', 'n', 'n', 'w', 'w', 'n', 'n', 'n', 'n'];
        s = '5'
          
    elseif Letter == ['n', 'n', 'w', 'w', 'w', 'n', 'n', 'n', 'n'];
        s = '6'
          
    elseif Letter == ['n', 'n', 'n', 'w', 'n', 'n', 'w', 'n', 'w'];
        s = '7'
          
    elseif Letter == ['w', 'n', 'n', 'w', 'n', 'n', 'w', 'n', 'n'];
        s = '8'
          
    elseif Letter == ['n', 'n', 'w', 'w', 'n', 'n', 'w', 'n', 'n'];
        s = '9'
          
    elseif Letter == ['w', 'n', 'n', 'n', 'n', 'w', 'n', 'n', 'w'];
        s = 'A'
          
    elseif Letter == ['n', 'n', 'w', 'n', 'n', 'w', 'n', 'n', 'w'];
        s = 'B'
          
    elseif Letter == ['w', 'n', 'w', 'n', 'n', 'w', 'n', 'n', 'n'];
        s = 'C'
          
    elseif Letter == ['n', 'n', 'n', 'n', 'w', 'w', 'n', 'n', 'w'];
        s = 'D'
          
    elseif Letter == ['w', 'n', 'n', 'n', 'w', 'w', 'n', 'n', 'n'];
        s = 'E'
          
    elseif Letter == ['n', 'n', 'w', 'n', 'w', 'w', 'n', 'n', 'n'];
        s = 'F'
          
    elseif Letter == ['n', 'n', 'n', 'n', 'n', 'w', 'w', 'n', 'w'];
        s = 'G'
          
    elseif Letter == ['w', 'n', 'n', 'n', 'n', 'w', 'w', 'n', 'n'];
        s = 'H'
          
    elseif Letter == ['n', 'n', 'w', 'n', 'n', 'w', 'w', 'n', 'n'];
        s = 'I'
          
    elseif Letter == ['n', 'n', 'n', 'n', 'w', 'w', 'w', 'n', 'n'];
        s = 'J'
          
    elseif Letter == ['w', 'n', 'n', 'n', 'n', 'n', 'n', 'w', 'w'];
        s = 'K'
          
    elseif Letter == ['n', 'n', 'w', 'n', 'n', 'n', 'n', 'w', 'w'];
        s = 'L'
          
    elseif Letter == ['w', 'n', 'w', 'n', 'n', 'n', 'n', 'w', 'n'];
        s = 'M'
          
    elseif Letter == ['n', 'n', 'n', 'n', 'w', 'n', 'n', 'w', 'w'];
        s = 'N'
          
    elseif Letter == ['w', 'n', 'n', 'n', 'w', 'n', 'n', 'w', 'n'];
        s = 'O'
          
    elseif Letter == ['n', 'n', 'w', 'n', 'w', 'n', 'n', 'w', 'n'];
        s = 'P'
          
    elseif Letter == ['n', 'n', 'n', 'n', 'n', 'n', 'w', 'w', 'w'];
        s = 'Q'
          
    elseif Letter == ['w', 'n', 'n', 'n', 'n', 'n', 'w', 'w', 'n'];
        s = 'R'
          
    elseif Letter == ['n', 'n', 'w', 'n', 'n', 'n', 'w', 'w', 'n'];
        s = 'S'
          
    elseif Letter == ['n', 'n', 'n', 'n', 'w', 'n', 'w', 'w', 'n'];
        s = 'T'
          
    elseif Letter == ['w', 'w', 'n', 'n', 'n', 'n', 'n', 'n', 'w'];
        s = 'U'
          
    elseif Letter == ['n', 'w', 'w', 'n', 'n', 'n', 'n', 'n', 'w'];
        s = 'V'
          
    elseif Letter == ['w', 'w', 'w', 'n', 'n', 'n', 'n', 'n', 'n'];
        s = 'W'
          
    elseif Letter == ['n', 'w', 'n', 'n', 'w', 'n', 'n', 'n', 'w'];
        s = 'X'
          
    elseif Letter == ['w', 'w', 'n', 'n', 'w', 'n', 'n', 'n', 'n'];
        s = 'Y'
          
    elseif Letter == ['n', 'w', 'w', 'n', 'w', 'n', 'n', 'n', 'n'];
        s = 'Z'
          
    elseif Letter == ['n', 'w', 'n', 'n', 'n', 'n', 'w', 'n', 'w'];
        s = '-'
          
    elseif Letter == ['w', 'w', 'n', 'n', 'n', 'n', 'w', 'n', 'n'];
        s = '/'
          
    elseif Letter == ['n', 'w', 'w', 'n', 'n', 'n', 'w', 'n', 'n'];
        s = ' '
          
    elseif Letter == ['n', 'w', 'n', 'w', 'n', 'w', 'n', 'n', 'n'];
        s = '$'
          
    elseif Letter == ['n', 'w', 'n', 'w', 'n', 'n', 'n', 'w', 'n'];
        s = '/'
          
    elseif Letter == ['n', 'w', 'n', 'n', 'n', 'w', 'n', 'w', 'n'];
        s = '+'
          
    elseif Letter == ['n', 'n', 'n', 'w', 'n', 'w', 'n', 'w', 'n'];
        s = '%'
          
    elseif Letter == ['n', 'w', 'n', 'n', 'w', 'n', 'w', 'n', 'n'];
        s = '*'
          
    end
    
    beginningOfWide = beginningOfWide + 9;
    outputIndex = outputIndex + 1;
end
