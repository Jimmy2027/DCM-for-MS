function plt_EC()
% PLT_EC() Calculates the node strengths for all sessions for both HC and MS
% patients. The node strengths are averaged over the patients.
% The function also plots the node strengths over the session and provides
% a linearized plot for the MS patients.
%-------------------------------------------------------------------------%
figure;
for data_type = {'MS', 'HC'}
    path = strcat('DCM/',data_type{1});
    x=[0,3,6,9,12];
    p_vec = zeros(2,7);
    delta_vec = zeros(5,7);

    EC_sessions = []; %EC values over sessions
    EC_stds = [];
    if data_type{1} == 'MS'
        nbr_sessions = 5
    elseif data_type{1} == 'HC'
        nbr_sessions = 2
    else
        disp('wrong function input')
    end

    for session=1:nbr_sessions
        EC_patients = []; %EC values over patients
        for pat =1:12
            %load A matrix for every patient
            DCM = load([path '/Sub_' num2str(pat) '_model_' num2str(1) '/session_' num2str(session) '.mat']);
            A = DCM.Ep.A;
            A = A - diag(diag(A));
            connection_strengths = [];
            for region = 1:7
                %calculate node strength for every region
                connection_strength= sum(A(:,region))+ sum(A(region,:)); 
                connection_strengths = [connection_strengths, connection_strength]; %node strenghts of patient "pat"
            end
            EC_patients = vertcat(EC_patients, connection_strengths);
        end
        %average region node strengths over patients
        EC_sessions = vertcat(EC_sessions, mean(EC_patients,1));
        EC_stds = vertcat(EC_stds, std(EC_patients,1));
    end

    %linear fit
    if data_type{1} == 'MS'
        for i = 1:7
           [p,S] = polyfit(x,EC_sessions(:,i)',1);
           p_vec(:,i)= p';
           [y,delta]=polyval(p,x,S);
           delta_vec(:,i)= delta';
        end
    end

    %plots 
    if data_type{1} == 'HC'
        subplot(2,2,1)
        xticks([0  12])
        xticklabels({'0 months','12 months'})
        axis([-1 13 -1 1.5])
    end
     
   if data_type{1} == 'MS'
       subplot(2,2,2)
       xticks([0 3 6 9 12])
       xticklabels({'0 months','3 months','6 months','9 months','12 months'})
       axis([-1 13 -1 1.5])

    end
    hold on;
    for i=1:7
        if data_type{1}=='MS'
            plot([0 3 6 9 12],EC_sessions(:,i),'-o')
        else
            plot([0 12],EC_sessions(:,i),'-o')   
        end
    end
    title(['Node strengths',' ',data_type{1}])
    legend('DGMN','Frontal','Prefrontal','Temporal','Parietal','Occipital','Cerebellum')
    ylabel('Node strength')
    xlabel('months from session 1')
    


    if data_type{1} == 'MS'
        subplot(2,2,4)
        for i = 1:7
            f =@(x) p_vec(1,i) *x +p_vec(2,i)
            inter= f(x);
            errorbar(x,inter,delta_vec(:,i),'-o');
            hold on
        end
        xlabel('months from session 1')
        title('Node strengths MS (linear regression)')
        legend('DGMN','Frontal','Prefrontal','Temporal','Parietal','Occipital','Cerebrellum')
        legend('Location','northeastoutside')
        xticks([0,3,6,9,12])
        xticklabels({'0 months','3 months','6 months','9 months','12 months'})
        ylabel('Node strength')
        axis([-1 13  -1 1.5])
        hold off
    end
end
end



