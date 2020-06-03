function specify_GCM(healthy,session)
%specify_GCM(healthy,session) constructs the group DCM files used in PEB
%for each session.
%------------------------------------------------------------------------%

    %creates folders to save group files and add paths to find the
    %previously saved DCMs for all subjects and sessions
    if healthy == true
        path = fullfile('DCM', 'HC');
        savepath = fullfile('GCM', 'HC');
        addpath(path)
        mkdir(savepath)
    else 
        path = fullfile('DCM', 'MS');
        savepath = fullfile('GCM', 'MS');
        addpath(path)
        mkdir(savepath)
    end
    
    %make group dcm files and save them
    GCM{12,1}= [];
    
    for j = 1:2 % both models
        for i = 1:1:12 %all subjects
            path_ = load([path '/Sub_' num2str(i) '_model_' num2str(j) '/session_' num2str(session) '.mat']);
            GCM{i} = path_.DCM;
        end
        name_ = ['GCM_model' num2str(j) '_session' num2str(session) '.mat'];
        save(fullfile(savepath,name_),'GCM');
    end
    
   
end

