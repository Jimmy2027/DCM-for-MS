
function read_data_specify_dcm(subject,model,session,healthy)
    
    addpath spm12
    addpath Data_preprocessed/MS
    addpath Data_preprocessed/HC

    %---------------------------initialize SPM----------------------------%
    spm('Defaults','fMRI');
    
    
    %---------------------------read data files---------------------------%
    %clear data and names before loading new mat file
    clear data
    clear names
    
    if subject < 10
        if healthy == true
           if session > 1
               load(['Data_preprocessed/HC/Subject00' num2str(subject) '/ROI_Subject00' num2str(subject) '_Session001_new.mat']);
           else
               load(['Data_preprocessed/HC/Subject00' num2str(subject) '/ROI_Subject00' num2str(subject) '_Session001.mat']);
           end
        else
           load(['Data_preprocessed/MS/Pat00' num2str(subject) '/ROI_Subject00' num2str(session) '_Session001.mat']); 
        end    
    else
        if healthy == true
           if session > 1
               load(['Data_preprocessed/HC/Subject0' num2str(subject) '/ROI_Subject0' num2str(subject) '_Session001_new.mat']);
           else
               load(['Data_preprocessed/HC/Subject0' num2str(subject) '/ROI_Subject0' num2str(subject) '_Session001.mat']);
           end
        else
           load(['Data_preprocessed/MS/Pat0' num2str(subject) '/ROI_Subject00' num2str(session) '_Session001.mat']); 
        end   
    end
    
   
    %-------------------------------model names---------------------------%
    models = {'fully connected', 'not connected'};
    clear DCM
    
    %---------------------------DCM options & params----------------------%
    %number of timepoints
    DCM.v = size(data,1);

    %number of regions
    DCM.n = size(data,2);
    
    rep_time =  10*60/(DCM.v); %200 timepoints in 10min
    DCM.delays = repmat(rep_time/2,DCM.n,1);
    DCM.TE     = 0.03;
    
    DCM.options.nonlinear  = 0;
    DCM.options.two_state  = 0;
    DCM.options.stochastic = 0;
    DCM.options.centre     = 0;
    DCM.options.endogenous = 0;
    DCM.options.nograph    = 1;

    
    %-----------------------------time series----------------------------%
    
    %assign each time series to DCM
    for k = 1: DCM.n
        DCM.Y.y(:,k) = data(:,k);
        DCM.Y.name{k} = names(k,:);
    end
    
    %specify error matrix for DCM
    DCM.Y.Q = spm_Ce(ones(1,DCM.n)*DCM.v);
   
    % RT 
    DCM.Y.dt = rep_time;
    
    % confound matrix (constant and DCT)
    %use spm_dcmtx to generate basis set 
    DCM.Y.X0 = {spm_dctmtx(DCM.v,1)};
    
    %-----------------------------drivng inputs--------------------------%
    
    %u = inputreader() %hendriks function to create exogenous inputs for resting state 
    DCM.U.u = ones(200,7);
    DCM.U.dt= DCM.Y.dt;
    DCM.U.name = 'input 0.04Hz mit gaussion noise';
    
    
    %--------------------specify DCM matrices dep. on model--------------%
    
    if model == 1
       name_model = models{model};
       DCM.a = ones(7);
       DCM.b = [0,0,0,0,0,0,0]';
       DCM.c = [0,0,0,0,0,0,0]';
       DCM.d = [0,0,0,0,0,0,0]'; %not non-linear
    else
       name_model = models{model};
       DCM.a = eye(7);
       DCM.b = [0,0,0,0,0,0,0]';
       DCM.c = [0,0,0,0,0,0,0]';
       DCM.d = [0,0,0,0,0,0,0]'; %not non-linear
    end
    
    
    %--------------------------save DCM struct---------------------------% 
    
    if healthy == true
        path = ['HC/Sub_',num2str(subject),'_model_',num2str(model)];
        mkdir('DCM',path)
        save(fullfile('DCM',path,['session_',num2str(session),'.mat']),'DCM');
        DCM_model_path = fullfile('DCM',path,['session_',num2str(session),'.mat']);
    else
        path = ['MS/Sub_',num2str(subject),'_model_',num2str(model)];
        mkdir('DCM',path)
        save(fullfile('DCM',path,['session_',num2str(session),'.mat']),'DCM');
        DCM_model_path = fullfile('DCM',path,['session_',num2str(session),'.mat']);
    end
    
    %---------------------------estimate DCM-----------------------------%
    %we used spectral DCM for estimation since we have resting state data
    %and specified zero inputs
    
    spm_dcm_fmri_csd(DCM_model_path)
    % data is saved directly into DCM files

end


















