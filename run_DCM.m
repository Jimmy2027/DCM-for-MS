 addpath spm12
 addpath Data_preprocessed/MS
 addpath Data_preprocessed/HC
 % for loops to go through all sessions, subjects/patients and models

% MS-Patients = 12 , Sessions 5

number = 12;
sessions = 5;
models = 2;

for i = 1:number
    for j = 1:sessions
        for k = 1:models
               read_data_specify_dcm(i,k,j,false)
        end
    end
end

% HC = 12 , Sessions = 2

sessions = 2;

for i = 1:number
    for j = 1:sessions
        for k = 1:models
               read_data_specify_dcm(i,k,j,true)
        end
    end
end