%function to run 2nd and third level analysis with parametric empirical
%bayes

%add spm12 path
addpath('spm12')

%------------------------------------------------------------------------%
%specify all the GCM files for analysis (MS patients)
no_sessions_MS = 5;


for k = 1: no_sessions_MS
    specify_GCM(false,k) %GCM for each session and model
end

specify_GCM_all(no_sessions_MS) % all MS together

%specify all the GCM files for analysis (HC )
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
% PEB for each session and model (spectral DCM) to have an overview --> full model PEB
% used for node strength calculation 

M.X = ones(12,1); % 12 subjects per group, group mean wanted
A_MS = [];
A_HC = [];
A_MS_2 = [];
A_HC_2 = [];

% all MS groups
for i = 1: no_sessions_MS
    for j = 1:2
        GCM = load([path_MS '/GCM_model' num2str(j) '_session' num2str(i) '.mat']);
        PEB = spm_dcm_peb(GCM.GCM,M,field);
        save([savepath_MS '/PEB_model' num2str(j) '_session' num2str(i) '_sDCM.mat'],'PEB');
        if j == 1
            A_MS = [A_MS,PEB.Ep];
        else
            A_MS_2 =[A_MS_2,PEB.Ep];
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
            A_HC = [A_HC,PEB.Ep];
        else
            A_HC_2 =[A_HC_2,PEB.Ep];
        end
    end
end

%calculations for node strength evaluation
calculate_node_strength(A_MS,A_HC);
calculate_node_strength(A_MS_2,A_HC_2);
%clear M.X

M.X = [];

% %------------------------------------------------------------------------%
% % PEB for each session and model (rDCM) --> full model PEB
% % used for node strength calculation 
% 
% %clear/reinizialize values
% M.X = ones(12,1); % 12 subjects per group, group mean wanted
% A_MS_s = [];  %sparse
% A_HC_s = [];
% A_MS_ns = []; %not sparse
% A_HC_ns = [];
% 
% for i = 1: no_sessions_MS
%     for j = 1:2 %sparse and not sparse (1: sparse, 2: not sparse)
%         if j == 1
%             GCM = load([path_rDCM '/GCM_MS_s' num2str(i) '_s.mat']);
%             GCM = GCM.GCM_MS';
%             PEB= spm_dcm_peb(GCM,M,field);
%             save([savepath_MS '/PEB_session' num2str(i) '_rDCM_s.mat'],'PEB');
%             A_MS_s = [A_MS_s,PEB.Ep];
%         else
%             GCM = load([path_rDCM '/GCM_MS_s' num2str(i) '_ns.mat']);
%             GCM = GCM.GCM_MS';
%             PEB = spm_dcm_peb(GCM,M,field);
%             save([savepath_MS '/PEB_session' num2str(i) '_rDCM_ns.mat'],'PEB');
%             A_MS_ns = [A_MS_ns,PEB.Ep];
%         end
%     end
% end
% 
% % all HC groups
% for i = 1: no_sessions_HC
%     for j = 1:2 %sparse and not sparse (1: sparse, 2: not sparse)
%         if j == 1
%             GCM = load([path_rDCM '/GCM_HC_s' num2str(i) '_s.mat']);
%             GCM = GCM.GCM_MS';
%             PEB= spm_dcm_peb(GCM,M,field);
%             save([savepath_HC '/PEB_session' num2str(i) '_rDCM_s.mat'],'PEB');
%             A_HC_s = [A_HC_s,PEB.Ep];
%         else
%             GCM = load([path_rDCM '/GCM_HC_s' num2str(i) '_ns.mat']);
%             if i == 1
%                 GCM = GCM.GCM_HC_s1';
%             else
%                 GCM = GCM.GCM_HC_s2';
%             end
%             PEB = spm_dcm_peb(GCM,M,field);
%             save([savepath_HC '/PEB_session' num2str(i) '_rDCM_ns.mat'],'PEB');
%             A_HC_ns = [A_HC_ns,PEB.Ep];
%         end
%     end
% end
% 
% calculate_node_strength(A_MS_s,A_HC_s); %sparse
% calculate_node_strength(A_MS_ns,A_HC_ns); % not sparse
% 
% M.X = []; %clear group level design matrix

%------------------------------------------------------------------------%
% comparison PEB with factorial design (main result)---> this is the factorial design we used for our results

% covariate 1 = mean effect
% covariate 2 = disease effect
% covariate 3 = time effect
% covariate 4 = interaction effect, time and disease
% GCM = {MS1,MS5,HC1,HC2}

X_comp = [ones(48,1) [ones(24,1);-ones(24,1)] [ones(12,1);-ones(12,1);ones(12,1);-ones(12,1)] [ones(12,1);-ones(12,1);-ones(12,1);ones(12,1)]];
M.X = X_comp;


%-----------------------------spectral DCM-------------------------------%
clear GCM;

% construct wanted GCM file out of the files with all sessions  
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

% %---------------------------------rDCM-----------------------------------%
% 
% % construct wanted GCM file out of the files with single sessions  
% GCM_MS_1 = load([path_rDCM '/GCM_MS_s1_ns.mat']);
% GCM_MS_5 = load([path_rDCM '/GCM_MS_s5_ns.mat']);
% GCM_MS_1 = GCM_MS_1.GCM_MS';
% GCM_MS_5 = GCM_MS_5.GCM_MS';
% 
% GCM_HC_1 = load([path_rDCM '/GCM_HC_s1_ns.mat']);
% GCM_HC_1 = GCM_HC_1.GCM_HC_s1';
% GCM_HC_2 = load([path_rDCM '/GCM_HC_s2_ns.mat']);
% GCM_HC_2 = GCM_HC_2.GCM_HC_s2';
% 
% GCM = [GCM_MS_1;GCM_MS_5;GCM_HC_1;GCM_HC_2];
% 
% %PEB 2nd level analysis
% PEB = spm_dcm_peb(GCM,M,field);
% 
% [BMA,BMR] = spm_dcm_peb_bmc(PEB); %BMC to find sparser model which describes our data
% spm_dcm_peb_review(BMA,GCM);  
% save('BMA/BMA_model1_main.mat','BMA')
% save('BMA/BMR_model1_main.mat','BMR')

% %our own plot tool to get nice plots of our results
% plot_data(BMA)
%------------------------------------------------------------------------%


