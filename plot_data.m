function plot_data(BMA)
%PLOT_DATA Plots the Expected posterior with convidence intervall over all
%the covariates threshholded with a probability >.95 
%-------------------------------------------------------------------------%
no_param = size(BMA.Pind,1);
Cov_post = BMA.Cp;
Ex_post = full(BMA.Ep);
Prob_post = BMA.Pp;
no_covariates = size(BMA.M.X,2);

X = categorical(cellstr(BMA.Pnames));
Y = [];
Y_2 = [];
y_part = [];
y_part_2 = [];

%threshhold with free energy
for i = 1:no_covariates
    for j = 1:no_param
        if Prob_post(no_param*(i-1)+j,1) < 0.95
            Ex_post(no_param*(i-1)+j,1)=0;
        end
    end
end

% threshhold using marginal variance
threshold = 0.95;
T  = 0;
Pp = 1 - spm_Ncdf(T,abs(BMA.Ep),diag(BMA.Cp));
Ep = BMA.Ep .* (Pp(:) > threshold);
Cp = BMA.Cp .* (Pp(:) > threshold);

%plot group mean 
figure;
bar(X,Ex_post(1:49,1))
ylabel('Effect Size')
title('Posterior Parameters')
legend('Group Mean')

%construct Y for stacked plots of the group effects
for j = 1:no_param
    for i = 2:4
     y_part = [y_part, Ex_post((i-1)*no_param+j,1)];
     y_part_2 = [y_part_2, Ep((i-1)*no_param+j,1)];
    end
    Y = [Y;y_part];
    Y_2 = [Y_2;y_part_2];
    y_part = [];
    y_part_2 = [];
end

% plot group effects thresholded with free energy >0.95
figure;
bar(X,Y,'stacked')
title('Posterior Parameters')
ylabel('Effect Size')
legend('Disease','Time','Interaction Disease/Time')

% plot group effectsthresholded with marginal variance >0.95
figure;
bar(X,Y_2,'stacked')
title('Posterior Parameters')
ylabel('Effect Size')
legend('Disease','Time','Interaction Disease/Time')

% %plot bar plots like spm with the two threshold methods
% for i = 1:no_covariates
%         figure;
%         %thresholded with free energy >0.95
%         spm_plot_ci(Ex_post((i-1)*no_param+1:i*no_param,1),Cov_post((i-1)*no_param+1:i*no_param,(i-1)*no_param+1:i*no_param));
%         figure;
%         %thresholded with marginal variance >0.95
%         spm_plot_ci(Ep((i-1)*no_param+1:i*no_param,1),Cp((i-1)*no_param+1:i*no_param,(i-1)*no_param+1:i*no_param));
% end




end


