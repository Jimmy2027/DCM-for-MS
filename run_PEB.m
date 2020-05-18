% %function to run 2nd and third level analysis with parametric empirical
% %bayes
% 
% %add spm12 path
addpath('spm12')
% 
% 
% %specify all the GCM files for analysis (MS patients)
no_sessions_MS = 5;
% 
% for k = 1: no_sessions_MS
%     specify_GCM(false,k)
% end
% 
% 
% %specify all the GCM files for analysis (HC )
% no_sessions_HC = 2;
% 
% for j = 1:no_sessions_HC
%     specify_GCM(true,j)
% end
% 
% 
% %2nd level analysis with PEB
% addpath('DCM/MS')
% addpath('DCM/HC')
% addpath('GCM/MS')
% addpath('GCM/HC')
% 
% % specify paths where to get GCMs and where to save PEBs
 path_MS = fullfile('GCM','MS');
 path_HC = fullfile('GCM','HC');
% savepath_MS = 'PEB/MS';
% savepath_HC = 'PEB/HC';
% 
% % make folders to save PEB 
% mkdir(savepath_MS)
% mkdir(savepath_HC)

%set up PEB
M = struct();
M.Q = 'all'; % between subject variabbility of each connection is estimated individually

% define covariates (here only constant)
no_subjects = 12;
M.X  = ones(no_subjects,1);

%choose what to estimate (for us A matrix)
field = {'A'};

%run PEB on all groups(GCMs)

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

% look for sparser models to describe the data



%BMA = spm_dcm_peb_bmc(PEB, GCM);


%compare session1 of HC and MS patients
M.X = ones(2*no_subjects,1);
covariate2 = [1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0]';
M.X = [M.X covariate2];

HC = load([path_HC '/GCM_model1_session1.mat']);
MS = load([path_MS '/GCM_model1_session1.mat']);
HC = HC.GCM;
MS = MS.GCM;
GCM = {HC{:},MS{:}}';
PEB = spm_dcm_peb(GCM,M.X);
spm_dcm_peb_review(PEB,GCM);


% compare MS patients over sessions 
X_MS_sessions = [ones(60,1) [ones(12,1);-ones(12,1); zeros(36,1)] [zeros(12,1);ones(12,1);-ones(12,1);zeros(24,1)] [zeros(24,1);ones(12,1);-ones(12,1);zeros(12,1)] [zeros(36,1);ones(12,1);-ones(12,1)]];

MS_gcm{5,1}=[];
for i = 1: no_sessions_MS
    temp =load([path_MS '/GCM_model1_session' num2str(i) '.mat']);
    MS_gcm{i}= temp.GCM;
end

GCM = {MS_gcm{1}{:},MS_gcm{2}{:},MS_gcm{3}{:},MS_gcm{4}{:},MS_gcm{5}{:}}'
PEB = spm_dcm_peb(GCM,X_MS_sessions);
spm_dcm_peb_review(PEB,GCM);

