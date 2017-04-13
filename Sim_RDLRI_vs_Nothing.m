clear;
clc;
close all;

addpath('DLRI');



%% Case 2 (Poisson)
no_floor = 9;
mean_poiss = 3;

E = poisspdf(0:no_floor-1,mean_poiss)';
E(no_floor+1) = 1-sum(E(1:no_floor));
L = 1/no_floor*ones(no_floor+1,1);


no_action = length(E);
%% Generate random request
% rng('default');
no_sim = 10000;
req_init    = zeros(no_sim,1);
req_end     = zeros(no_sim,1);
for n = 1:no_sim
    cum_P = cumsum(E);
    req_init(n) = find(rand()<cum_P,1);
    cum_P = cumsum(L);
    while true
        req_end(n)  = find(rand()<cum_P,1);
        if req_end(n) ~= req_init(n)
            break;
        end
    end
    
end


%% VSSR--LRI scheme Simulation
ci = ones(no_action,1);
no_states = 1000;
Ki = 0.999;
elev_init = 3; %set elevator to the ground floor
no_step = 1000;
no_train = 1000;
action = zeros(no_sim-no_train,1);
overall_time_DLRI = 0;
T_DLRI = zeros(no_sim,1);
for n = 1:no_train
    T1 = Overall_Time(elev_init,req_end(n),req_init(n),req_end(n));
    overall_time_DLRI = overall_time_DLRI + T1;
    T_DLRI(n) = overall_time_DLRI;
    [ci] = Environment_update(Ki,req_init(n),ci);
    elev_init = req_end(n);
end
for n = no_train+1:no_sim
    init_Prob = 1/no_action*ones(no_action,1);
    [action(n-no_train)] = Sim_RDLRI(no_step,ci,init_Prob,no_states);
    elev_end = action(n-no_train);
    [T1] = Overall_Time(elev_init,elev_end,req_init(n),req_end(n));
    overall_time_DLRI = overall_time_DLRI + T1;
    T_DLRI(n) = overall_time_DLRI;
    elev_init = elev_end;
end

%% Doing nothing scheme Simulation
elev_init = 3;
overall_time_nothing = 0;
T_nothing = zeros(no_sim,1);
for n = 1:no_sim
    T2 = Overall_Time(elev_init,req_end(n),req_init(n),req_end(n));
    overall_time_nothing = overall_time_nothing + T2;
    T_nothing(n) = overall_time_nothing;
    elev_init = req_end(n);
end



disp(overall_time_DLRI);
disp(overall_time_nothing);








load('LRI_results.mat');

figure(1);
plot(1:no_sim,T_DLRI,'-o','linewidth',2);
hold all;
plot(1:no_sim,T_LRI,'-*','linewidth',2);
plot(1:no_sim,T_nothing,'-.','linewidth',2);
hold off;
legend('DLRI','LRI','doing-nothing');
xlabel('Number of Simulation','FontSize',12);
ylabel('overall time','FontSize',12);

FN = 'DLRI_20';
print(gcf, '-depsc2','-r600',strcat(FN,'_c'));  % Encapsulated PostScript Level 2 color

x_vec = (1:no_floor+1);
figure(2);
histogram(req_init);
% plot(x_vec,E,'linewidth',3);
xlabel('Floor');
ylabel('Probability');
xlim([min(x_vec),max(x_vec)]);
FN = 'DLRI_E_20';
print(gcf, '-depsc2','-r600',strcat(FN,'_c'));  % Encapsulated PostScript Level 2 color

figure(3);
plot(x_vec,ci,'linewidth',3);
xlim([min(x_vec),max(x_vec)]);
xlabel('Floor','FontSize',12);
ylabel('Probability','FontSize',12);

FN = 'DLRI_ci_20';
print(gcf, '-depsc2','-r600',strcat(FN,'_c'));  % Encapsulated PostScript Level 2 color

figure(4);
histogram(action);
xlim([min(x_vec),max(x_vec)]);
xlabel('Floor','FontSize',12);
FN = 'DLRI_action_20';
print(gcf, '-depsc2','-r600',strcat(FN,'_c'));  % Encapsulated PostScript Level 2 color
