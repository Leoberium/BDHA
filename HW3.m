clc; home;
close all hidden
clear;

% Load exam data
load('Data.mat', 'Data');

% Data columns in PatData
nPatID=1; % patient ID 
nArrive=2; % patient arrive time
nBegin=3; % patient exam begin time
nComplete=4; % patient exam end time
nTech=5; % tech who performed the exam
nMinMod=6; % reminder after dividing patient exam begin time by 10

TechList = (1:max(Data(:, nTech)))';

Data(:, nMinMod) = mod(minute(Data(:, nBegin)), 10);

for i = TechList(:, 1)'
    % Quantity of exams for each tech
    TechList(i, 2) = sum(Data(:, nTech) == i);
    % Quantity of biased time inputs for each tech
    TechList(i, 3) = sum(Data(Data(:, nTech) == i, nMinMod) == 0);
end

for i = TechList(TechList(:,2) >= 10)'
    % Probability of bias for each tech with more than 9 exams
    TechList(i, 4) = TechList(i, 3)/TechList(i, 2);
end

TechListSorted = sortrows(TechList, 4, 'descend');
TheMostBiasedTech = TechListSorted(1, 1);

PatientWaitingLineSize = zeros(1051,1);

 for i = Data(:, nPatID)'
     PatientWaitingLineSize(i) = sum(all([Data(i, nArrive) >= Data(:, nArrive) Data(i, nArrive) <= Data(:, nBegin)]'));   
 end
LongestWaitingLine = max(PatientWaitingLineSize);

fprintf('The most biased tech is the tech number: %d.\n', TheMostBiasedTech)
fprintf('The longest patient waiting line in this facility was: %d.\n', LongestWaitingLine)





