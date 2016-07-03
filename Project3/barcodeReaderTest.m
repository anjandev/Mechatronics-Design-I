clc
clear all
close all

%% Constants

INDEX_TO_START_AT = 3; % REMEMBER NOT 0 INDEXED. MUST BE ODD NUMBER. Change this to inc/dec ingored values at the beginning
SAMPLING_TIME=30e-3;
DATA_COLUMN = 1;

% For moving average
WINDOW_SIZE = 1;

% For find peaks
MinPeakDistance = 0;
MinPeakHeight = 50;

%% Parsing Data

MyRawImage = imread('Sample_LetterA.jpg');
MyRawImage = double(MyRawImage);

MyLightVals = MyRawImage(35,:,1);

MyLightVals = MyLightVals(10:length(MyLightVals)-100);

% read every second value
%for i=2:2:length(lightDataWithIndices)
% lightDataNoIndices(noIndicesIndex)= lightDataWithIndices(i);
% noIndicesIndex = noIndicesIndex + 1;
%end

% For Test
for i=1:1:length(MyLightVals)
 lightDataNoIndices(i)= MyLightVals(i);
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

[pks,locs]= findpeaks(MyLightVals_avg_der,'MinPeakDistance', MinPeakDistance, 'MINPEAKHEIGHT', MinPeakHeight);

% Shift locs over by one because everything while drawing is zero indexed
% IE time=0:SAMPLING_TIME:(length(MovingAvg)-1)*SAMPLING_TIME;
% NOTE: Might cause a bug but since I just get the difference for width,
% I dont think it will
%for i=1:length(locs)-1
%    locs(i) = locs(i)-1;
%end

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

%plot(timeNoIndices, lightDataNoIndices)
hold on
%plot(time, MovingAvg,'r')
hold on
plot(timeDer, MyLightVals_avg_der,'k') %in green
hold on
plot(timePks,pks,'or') %o is circle, r is red

%% Wide and narrow finder

averageWidth = (max(widths) + min(widths)) / 2;
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
    if i + 8 <= length(wideOrNarrow)
        Letter = wideOrNarrow(i:i+8);
    else
        break
    end
    
    if Letter == ['n', 'n', 'n', 'w', 'w', 'n', 'w', 'n', 'n'];
        s = '0'
        Letters(outputIndex) = s
    elseif Letter == ['w', 'n', 'n', 'w', 'n', 'n', 'n', 'n', 'w'];
        s = '1'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'w', 'w', 'n', 'n', 'n', 'n', 'w'];
        s = '2'
        Letters(outputIndex) = s
    elseif Letter == ['w', 'n', 'w', 'w', 'n', 'n', 'n', 'n', 'n'];
        s = '3'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'n', 'w', 'w', 'n', 'n', 'n', 'w'];
        s = '4'
        Letters(outputIndex) = s
    elseif Letter == ['w', 'n', 'n', 'w', 'w', 'n', 'n', 'n', 'n'];
        s = '5'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'w', 'w', 'w', 'n', 'n', 'n', 'n'];
        s = '6'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'n', 'w', 'n', 'n', 'w', 'n', 'w'];
        s = '7'
        Letters(outputIndex) = s
    elseif Letter == ['w', 'n', 'n', 'w', 'n', 'n', 'w', 'n', 'n'];
        s = '8'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'w', 'w', 'n', 'n', 'w', 'n', 'n'];
        s = '9'
        Letters(outputIndex) = s
    elseif Letter == ['w', 'n', 'n', 'n', 'n', 'w', 'n', 'n', 'w'];
        s = 'A'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'w', 'n', 'n', 'w', 'n', 'n', 'w'];
        s = 'B'
        Letters(outputIndex) = s
    elseif Letter == ['w', 'n', 'w', 'n', 'n', 'w', 'n', 'n', 'n'];
        s = 'C'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'n', 'n', 'w', 'w', 'n', 'n', 'w'];
        s = 'D'
        Letters(outputIndex) = s
    elseif Letter == ['w', 'n', 'n', 'n', 'w', 'w', 'n', 'n', 'n'];
        s = 'E'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'w', 'n', 'w', 'w', 'n', 'n', 'n'];
        s = 'F'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'n', 'n', 'n', 'w', 'w', 'n', 'w'];
        s = 'G'
        Letters(outputIndex) = s
    elseif Letter == ['w', 'n', 'n', 'n', 'n', 'w', 'w', 'n', 'n'];
        s = 'H'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'w', 'n', 'n', 'w', 'w', 'n', 'n'];
        s = 'I'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'n', 'n', 'w', 'w', 'w', 'n', 'n'];
        s = 'J'
        Letters(outputIndex) = s
    elseif Letter == ['w', 'n', 'n', 'n', 'n', 'n', 'n', 'w', 'w'];
        s = 'K'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'w', 'n', 'n', 'n', 'n', 'w', 'w'];
        s = 'L'
        Letters(outputIndex) = s
    elseif Letter == ['w', 'n', 'w', 'n', 'n', 'n', 'n', 'w', 'n'];
        s = 'M'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'n', 'n', 'w', 'n', 'n', 'w', 'w'];
        s = 'N'
        Letters(outputIndex) = s
    elseif Letter == ['w', 'n', 'n', 'n', 'w', 'n', 'n', 'w', 'n'];
        s = 'O'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'w', 'n', 'w', 'n', 'n', 'w', 'n'];
        s = 'P'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'n', 'n', 'n', 'n', 'w', 'w', 'w'];
        s = 'Q'
        Letters(outputIndex) = s
    elseif Letter == ['w', 'n', 'n', 'n', 'n', 'n', 'w', 'w', 'n'];
        s = 'R'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'w', 'n', 'n', 'n', 'w', 'w', 'n'];
        s = 'S'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'n', 'n', 'w', 'n', 'w', 'w', 'n'];
        s = 'T'
        Letters(outputIndex) = s
    elseif Letter == ['w', 'w', 'n', 'n', 'n', 'n', 'n', 'n', 'w'];
        s = 'U'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'w', 'w', 'n', 'n', 'n', 'n', 'n', 'w'];
        s = 'V'
        Letters(outputIndex) = s
    elseif Letter == ['w', 'w', 'w', 'n', 'n', 'n', 'n', 'n', 'n'];
        s = 'W'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'w', 'n', 'n', 'w', 'n', 'n', 'n', 'w'];
        s = 'X'
        Letters(outputIndex) = s
    elseif Letter == ['w', 'w', 'n', 'n', 'w', 'n', 'n', 'n', 'n'];
        s = 'Y'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'w', 'w', 'n', 'w', 'n', 'n', 'n', 'n'];
        s = 'Z'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'w', 'n', 'n', 'n', 'n', 'w', 'n', 'w'];
        s = '-'
        Letters(outputIndex) = s
    elseif Letter == ['w', 'w', 'n', 'n', 'n', 'n', 'w', 'n', 'n'];
        s = '/'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'w', 'w', 'n', 'n', 'n', 'w', 'n', 'n'];
        s = ' '
        Letters(outputIndex) = s
    elseif Letter == ['n', 'w', 'n', 'w', 'n', 'w', 'n', 'n', 'n'];
        s = '$'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'w', 'n', 'w', 'n', 'n', 'n', 'w', 'n'];
        s = '/'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'w', 'n', 'n', 'n', 'w', 'n', 'w', 'n'];
        s = '+'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'n', 'n', 'w', 'n', 'w', 'n', 'w', 'n'];
        s = '%'
        Letters(outputIndex) = s
    elseif Letter == ['n', 'w', 'n', 'n', 'w', 'n', 'w', 'n', 'n'];
        s = '*'
        Letters(outputIndex) = s
    end
    
    beginningOfWide = beginningOfWide + 9;
    outputIndex = outputIndex + 1;
end
Letters
