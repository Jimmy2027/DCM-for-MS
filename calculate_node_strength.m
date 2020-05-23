function calculate_node_strength(A_MS,A_HC)
%inizialize 
A_MS= full(A_MS);
A_HC= full(A_HC);  

node_strength_MS= zeros(7,5);
node_strength_HC= zeros(7,2);
p_vec = zeros(2,7);
delta_vec = zeros(5,7);; 

% MS patients (5 sessions)
x=[0,3,6,9,12];
for i = 1:5
    A = A_MS(1:49,i);
    A = [A(1:7)';A(8:14)';A(15:21)';A(22:28)';A(29:35)';A(36:42)';A(43:49)'];
    for j = 1:7
        node_strength_MS(j,i)= (sum(A(2:7,j))+sum(A(j,2:7))+exp(-A(j,j)))/13;
    end
end
for i = 1:7
   [p,S] = polyfit(x,node_strength_MS(i,:),1);
   p_vec(:,i)= p';
   [y,delta]=polyval(p,x,S);
   delta_vec(:,i)= delta';
end

% HC (2 sessions)
for i = 1:2
    A = A_HC(1:49,i);
    A = [A(1:7)';A(8:14)';A(15:21)';A(22:28)';A(29:35)';A(36:42)';A(43:49)'];
    for j = 1:7
        node_strength_HC(j,i)= (sum(A(2:7,j))+sum(A(j,2:7))+exp(-A(j,j)))/13;
    end
end

% plot results
figure;
subplot(2,2,1)
plot([0,12],node_strength_HC','-o')
legend('DGMN','Frontal','Prefrontal','Temporal','Parietal','Occipital','Cerebrellum')
axis([-1 13 0 0.4])
title('Node strengths HC')
xlabel('months from session 1')
ylabel('node strength normalized')

subplot(2,2,2)
plot([0,3,6,9,12],node_strength_MS','-o')
legend('DGMN','Frontal','Prefrontal','Temporal','Parietal','Occipital','Cerebrellum')
axis([-1 13 0 0.4])
title('Node strengths MS')
xlabel('months from session 1')
ylabel('node strength normalized')

subplot(2,2,4)
for i = 1:7
    f =@(x) p_vec(1,i) *x +p_vec(2,i)
    inter= f(x);
    errorbar(x,inter,delta_vec(:,i),'-o');
    hold on
end
axis([-1 13  0 0.4])
xlabel('months from session 1')
title('Node strengths MS (linear regression)')
legend('DGMN','Frontal','Prefrontal','Temporal','Parietal','Occipital','Cerebrellum')
ylabel('node strength normalized')
hold off

end

