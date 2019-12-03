clc; home;
close all hidden
clear;
%{
Data = readtable('data.xlsx');
Data.dtArrive = datenum(Data.dtArrive);
Data.dtBegin = datenum(Data.dtBegin);
MinutesInDay = 24*60;
Data.WaitPatient = MinutesInDay*(Data.dtBegin - Data.dtArrive);

% Merging exams for the same patient
Data = sortrows(Data, {'stModality', 'stMRN', 'dtBegin'});
Data.RepeatedMRN = zeros(size(Data.stMRN));
nData = length(Data.dtArrive);

for i = 2:nData
    if Data.stMRN(i - 1) == Data.stMRN(i) && Data.dtArrive(i) < Data.dtBegin(i - 1)
        Data.RepeatedMRN(i) = 1;
    end
end

Data = Data(Data.RepeatedMRN == 0, :);
Data.RepeatedMRN = [];

nData = length(Data.dtArrive);
Data = sortrows(Data, 'dtArrive');
Data.L0 = zeros(size(Data.stMRN)); % waiting now
Data.L1 = Data.L0; % waiting 5 mins ago
Data.L2 = Data.L0; % waiting 10 mins ago

for i = 1:nData
    tnow = Data.dtArrive(i);
    tnow5 = tnow - 5/MinutesInDay;
    tnow10 = tnow - 10/MinutesInDay;
    Data.L0(i) = length(find(Data.dtArrive < tnow & Data.dtBegin > tnow));
    Data.L1(i) = length(find(Data.dtArrive < tnow5 & Data.dtBegin > tnow5));
    Data.L2(i) = length(find(Data.dtArrive < tnow10 & Data.dtBegin > tnow10));
end

save('PrData.mat', 'Data');
%}
load('PrData.mat')

% Initializing intercept and predictor variables:
I = ones(size(Data.L0));
Y = Data.WaitPatient;

% Running regression model 1 (Intercept I only):
[~, ~, r, ~, ~] = regress(Y, I);
rmed1 = median(abs(r));
acc1 = length(r(abs(r) <= 5))/length(r);

% Running regression model 2 (I L0):
[~, ~, r, ~, ~] = regress(Y, [I Data.L0]);
rmed2 = median(abs(r));
acc2 = length(r(abs(r) <= 5))/length(r);

% Running regression model 3 (I L0 L1):
[~, ~, r, ~, ~] = regress(Y, [I Data.L0 Data.L1]);
rmed3 = median(abs(r));
acc3 = length(r(abs(r) <= 5))/length(r);

% Running regression model 4 (I L0 L1, best 80%):
q = quantile(abs(r), 0.8);
inds = find(abs(r) < q);
[~, ~, r, ~, ~] = regress(Y(inds, :), [I(inds, :) Data.L0(inds, :) Data.L1(inds, :)]);
rmed4 = median(abs(r));
acc4 = length(r(abs(r) <= 5))/length(r);

% Just because of curiosity:
% Running regression model 5 (I L0 L1 L2):
[~, ~, r, ~, ~] = regress(Y, [I Data.L0 Data.L1 Data.L2]);
rmed5 = median(abs(r));
acc5 = length(r(abs(r) <= 5))/length(r);

% Running regression model 6 (I L0 L1 L2, best 80%):
q = quantile(abs(r), 0.8);
inds = find(abs(r) < q);
[~, ~, r, ~, ~] = regress(Y(inds, :), [I(inds, :) Data.L0(inds, :) Data.L1(inds, :) Data.L2(inds, :)]);
rmed6 = median(abs(r));
acc6 = length(r(abs(r) <= 5))/length(r);

fprintf('Median of absolute residual values: \n Model1: %1.2f \n Model2: %1.2f \n Model3: %1.2f \n Model4: %1.2f \n Model5: %1.2f \n Model6: %1.2f \n', rmed1, rmed2, rmed3, rmed4, rmed5, rmed6)
fprintf('Predicted with 5-minute accuracy: \n Model1: %0.3f \n Model2: %0.3f \n Model3: %0.3f \n Model4: %0.3f \n Model5: %0.3f \n Model6: %0.3f \n', acc1, acc2, acc3, acc4, acc5, acc6)
