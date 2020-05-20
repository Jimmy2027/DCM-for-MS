%function to run 2nd and third level analysis with parametric empirical
%bayes

%add spm12 path
addpath('spm12')


%specify all the GCM files for analysis (MS patients)
 no_sessions_MS = 5;
 
 specify_GCM_all(no_sessions_MS) % all MS together

for k = 1: no_sessions_MS
    specify_GCM(false,k) 
end


%specify all the GCM files for analysis (HC )
 no_sessions_HC = 2;
 
 specify_GCM_all(no_sessions_HC) % all HC together

for j = 1:no_sessions_HC
    specify_GCM(true,j)
end

%2nd level analysis with PEB
addpath('GCM/MS')
addpath('GCM/HC')

% specify paths where to get GCMs and where to save PEBs
path_MS = fullfile('GCM','MS');
path_HC = fullfile('GCM','HC');
savepath_MS = 'PEB/MS';
savepath_HC = 'PEB/HC';

% make folders to save PEB 
mkdir(savepath_MS)
mkdir(savepath_HC)

%-------------------------------------------------------------------------------------------------------%
%set up PEB
M = struct();
M.Q = 'all'; % between subject variabbility of each connection is estimated individually

% define covariates (here only constant)
no_subjects = 12;
M.X  = ones(no_subjects,1);

%choose what to estimate (for us A matrix)
field = {'A'};

%-------------------------------------------------------------------------------------------------------%
%run PEB on all groups(GCMs)  ---> not used at the momentß

% % all MS groups
% for i = 1: no_sessions_MS
%     for j = 1:2
%         GCM = load([path_MS '/GCM_model' num2str(j) '_session' num2str(i) '.mat']);
%         PEB= spm_dcm_peb(GCM.GCM,M,field);
%         
%         save([savepath_MS '/PEB_model' num2str(j) '_session' num2str(i) '.mat'],'PEB');
%     end
% end
% 
% % all HC groups
% for i = 1: no_sessions_HC
%     for j = 1:2
%         GCM = load([path_HC '/GCM_model' num2str(j) '_session' num2str(i) '.mat']);
%         PEB= spm_dcm_peb(GCM.GCM,M,field);
%   
%         save([savepath_HC '/PEB_model' num2str(j) '_session' num2str(i) '.mat'],'PEB');
%     end
% end


%-------------------------------------------------------------------------------------------------------%
% look for sparser models to describe the data (used all sessions for both HC and MS) ---> not used at the moment

% % HC %
% GCM = load([path_HC '/GCM_model1_all_sessions.mat' ]); % load GCM with all sessions of HC
% M.X = ones(no_subjects*no_sessions_HC,1);              % update covariate matrix to right dimensions
% PEB = spm_dcm_peb(GCM.GCM,M,field);                    % run PEB
% save([savepath_HC '/PEB_model1_all_sessions.mat'],'PEB');
% [BMA, BMR]= spm_dcm_peb_bmc(PEB);                            % look for sparse models for HC
% spm_dcm_peb_review(BMA,GCM.GCM);                       % look at found models
% mkdir('BMA/HC')
% save('BMA/HC/BMA_model1_all_sessions.mat','BMA')
% save('BMA/HC/BMR_model1_all_sessions.mat','BMA')
% 
% % MS %
% GCM = load([path_MS '/GCM_model1_all_sessions.mat' ]); % load GCM with all sessions of MS patients
% M.X = ones(no_subjects*no_sessions_MS,1);              % update covariate matrix to right dimensions
% PEB = spm_dcm_peb(GCM.GCM,M,field);                    % run PEB
% save([savepath_MS '/PEB_model1_all_sessions.mat'],'PEB');
% [BMA,BMR]= spm_dcm_peb_bmc(PEB);                            % look for sparse models for MS patients
% spm_dcm_peb_review(BMA,GCM.GCM);                       % look at found models
% mkdir('BMA/MS')
% save('BMA/MS/BMA_model1_all_sessions.mat','BMA')
% save('BMA/MS/BMR_model1_all_sessions.mat','BMA')
                                             
                                                      
savepath_comp= 'PEB/Comp';
mkdir(savepath_comp);

%-------------------------------------------------------------------------------------------------------%
% comparison PEB with factorial design (main result)---> this is the factorial design we used for our results

% covariate 1 = mean effect
% covariate 2 = disease effect
% covariate 3 = time effect
% covariate 4 = interaction effect, time and disease
% GCM = {MS1,MS5,HC1,HC2}

X_comp = [ones(48,1) [ones(24,1);-ones(24,1)] [ones(12,1);-ones(12,1);ones(12,1);-ones(12,1)] [ones(12,1);-ones(12,1);-ones(12,1);ones(12,1)]];
GCM_MS = load([path_MS '/GCM_model1_all_sessions.mat' ]);
GCM_HC = load([path_HC '/GCM_model1_all_sessions.mat' ]);
GCM_MS = [GCM_MS.GCM(1:12,1); GCM_MS.GCM(49:60,1)];
GCM_HC = GCM_HC.GCM;
GCM = [GCM_MS;GCM_HC];
PEB = spm_dcm_peb(GCM,X_comp,field);
save([savepath_comp '/PEB_model1_main.mat'],'PEB');
[BMA,BMR] = spm_dcm_peb_bmc(PEB); 
spm_dcm_peb_review(BMA,GCM);  
save('BMA/BMA_model1_main.mat','BMA')
save('BMA/BMR_model1_main.mat','BMR')

%our own plot tool
plot_data(BMA)

