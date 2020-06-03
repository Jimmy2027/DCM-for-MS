%function to run 2nd level analysis with parametric empirical
%bayes to fin the effects of disease, time and the interaction of the both
%------------------------------------------------------------------------%

%add spm12 path
addpath('spm12')

%------------------------------------------------------------------------%
%specify all the GCM files for analysis (MS patients)
no_sessions_MS = 5;


for k = 1: no_sessions_MS
    specify_GCM(false,k) %GCM for each session and model
end

specify_GCM_all(no_sessions_MS) % all MS together

%specify all the GCM files for analysis (HC)
 no_sessions_HC = 2;

for j = 1:no_sessions_HC
    specify_GCM(true,j) %GCM for each session and model
end

specify_GCM_all(no_sessions_HC) % all HC together

%------------------------------------------------------------------------%
% specify paths where to get GCMs and where to save PEBs
path_MS = fullfile('GCM','MS');
path_HC = fullfile('GCM','HC');
path_rDCM = fullfile('rDCM','GCM_Data');
savepath_MS = 'PEB/MS';
savepath_HC = 'PEB/HC';
savepath_comp= 'PEB/Comp';

% make folders to save PEB 
mkdir(savepath_MS)
mkdir(savepath_HC)
mkdir(savepath_comp);
mkdir('BMA');

%------------------------------------------------------------------------%
%set up PEB
M = struct();
M.Q = 'all'; % between subject variabbility of each connection is estimated individually
%M.X will be defined seperately depending on the question asked

%choose what to estimate (for us A matrix)
field = {'A'};
                                                      
%------------------------------------------------------------------------%
% PEB for each session and model (spectral DCM) to have an overview 
% could be used for node strength calculation after group averaging with
% PEB --> was not used to generate the node strength results in the report

M.X = ones(12,1); % 12 subjects per group, group mean wanted
A_MS = [];
A_HC = [];

% all MS groups
for i = 1: no_sessions_MS
    for j = 1:2
        GCM = load([path_MS '/GCM_model' num2str(j) '_session' num2str(i) '.mat']);
        PEB = spm_dcm_peb(GCM.GCM,M,field);
        save([savepath_MS '/PEB_model' num2str(j) '_session' num2str(i) '_sDCM.mat'],'PEB');
        if j == 1
            A_MS = [A_MS,PEB.Ep]; %for node strength calculation after PEB
        end
    end
end

% all HC groups
for i = 1: no_sessions_HC
    for j = 1:2
        GCM = load([path_HC '/GCM_model' num2str(j) '_session' num2str(i) '.mat']);
        PEB = spm_dcm_peb(GCM.GCM,M,field);
        save([savepath_HC '/PEB_model' num2str(j) '_session' num2str(i) '_sDCM.mat'],'PEB');
        if j == 1
            A_HC = [A_HC,PEB.Ep]; %for node strength calculation after PEB
        end
    end
end

%calculations for node strength evaluation
calculate_node_strength(A_MS,A_HC)
M.X = [];

%------------------------------------------------------------------------%
% comparison PEB with factorial design (main result)---> this is the factorial design we used for our results

% covariate 1 = mean group effect
% covariate 2 = disease effect
% covariate 3 = time effect
% covariate 4 = interaction effect, time and disease
% GCM = {MS1,MS5,HC1,HC2}

X_comp = [ones(48,1) [ones(24,1);-ones(24,1)] [ones(12,1);-ones(12,1);ones(12,1);-ones(12,1)] [ones(12,1);-ones(12,1);-ones(12,1);ones(12,1)]];
M.X = X_comp;


%-----------------------------spectral DCM-------------------------------%
clear GCM;

% construct wanted GCM file out of the files with all sessions  
% MS1,MS5 and HC1,HC2 --> 4 groups for factorial design
GCM_MS = load([path_MS '/GCM_model1_all_sessions.mat' ]);
GCM_HC = load([path_HC '/GCM_model1_all_sessions.mat' ]);
GCM_MS = [GCM_MS.GCM(1:12,1); GCM_MS.GCM(49:60,1)];
GCM_HC = GCM_HC.GCM;
GCM_all = [GCM_MS;GCM_HC];


%PEB 2nd level analysis
PEB = spm_dcm_peb(GCM_all,M,field); %PEB
save([savepath_comp '/PEB_model1_main_sDCM.mat'],'PEB');

[BMA,BMR] = spm_dcm_peb_bmc(PEB); %BMC to find sparser model which describes our data
spm_dcm_peb_review(BMA,GCM_all);  
save('BMA/BMA_model1_main.mat','BMA')
save('BMA/BMR_model1_main.mat','BMR')

%our own plot tool to get nice plots of our results
plot_data(BMA)




