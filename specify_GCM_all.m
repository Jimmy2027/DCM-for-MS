function specify_GCM_all(no_sessions)
%specify_GCM_all(healthy,session) constructs the group DCM files used in PEB
%for each group (HC,MS) over all sessions
%------------------------------------------------------------------------%

    %creates folders to save group files and add paths to find the
    %previously saved DCMs for all subjects and sessions
    if no_sessions == 5
        path = 'DCM/MS';
        savepath = 'GCM/MS';
        
    else
        path = 'DCM/HC';
        savepath = 'GCM/HC';
    end

    GCM_all={};

    %construct GCM-files and save them
    for k = 1:2
        for j = 1: no_sessions
            for i = 1:12
                path_ = load([path '/Sub_' num2str(i) '_model_' num2str(k) '/session_' num2str(j) '.mat']);
                GCM{i} = path_.DCM;  
            end
            temp = GCM;
            GCM_all = [GCM_all temp{:}];
        end
        name_ = ['GCM_model' num2str(k) '_all_sessions.mat'];
        GCM = GCM_all';
        save(fullfile(savepath,name_),'GCM');
        clear GCM;
    end

end

