DirName = 'D:\Medical Informatics\HW2\Clinical_HL7_Samples\';
filelist = cellstr(ls([DirName '*.out']));

RawSegments = cell(1,301);
for i = 1:length(filelist)
    %RawSegments{i} = textread(filelist{i},'%s','delimiter','\n');
    fid = fopen([DirName filelist{i}]);
    RawSegments{i} = textscan(fid,'%s');
    fclose(fid);    
end

Segments = cell(301,2);
for i = 1:length(RawSegments)
    for j = 2:3 %PID only here
        Segments{i,j-1} = RawSegments{i}{1}{j};
    end
end

Segments(1:78,1) = Segments(1:78,2);
Segments(195:219,1) = Segments(195:219,2);
Segments(270:301,1) = Segments(270:301,2);
Segments(:,2) = [];

SegmentsSplitted = cell(301,25);

for i = 1:length(Segments)
    prestring = strsplit(Segments{i},'|');
    for j = 1:length(prestring)
        SegmentsSplitted{i,j} = prestring{j};
    end
end

RawNames(:,1) = strrep(SegmentsSplitted(:,4),'^^','');
RawDates(:,1) = SegmentsSplitted(:,5);

DateTimeMatlab = datenum(RawDates,'yyyymmdd');

PatientNameArray = cell(301,4);
for i = 1:length(RawNames)
    prename = strsplit(RawNames{i},'^');
    for j = 1:length(prename)
        PatientNameArray{i,j} = prename{j};
    end
end

PatientNameArray(:,3:end) = [];
UniquePatientNames = unique(PatientNameArray(:,2));

datestr(min(DateTimeMatlab))
length(unique(RawNames))
