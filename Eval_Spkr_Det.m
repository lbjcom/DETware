function [] = Eval_Spkr_Det(target_name, imposter_name)
%------------------------------
%load speaker detection output scores

fp_target = fopen(target_name);
target_score = textscan(fp_target, "%s %s %d %s %f", 'delimiter', ' ');
target_score = target_score{1,5};

fp_imposter = fopen(imposter_name);
imposter_score = textscan(fp_imposter, "%s %s %d %s %f", 'delimiter', ' ');
imposter_score = imposter_score{1,5};

%------------------------------
%initialize the DCF parameters
Set_DCF (10, 1, 0.01);

%------------------------------
%compute Pmiss and Pfa from experimental detection output scores
[P_miss,P_fa] = Compute_DET (target_score, imposter_score);

%------------------------------
%plot results

% Set tic marks
Pmiss_min = 0.001;
Pmiss_max = 0.20;
Pfa_min = 0.001;
Pfa_max = 0.20;
Set_DET_limits(Pmiss_min,Pmiss_max,Pfa_min,Pfa_max);

%call figure, plot DET-curve
figure;
Plot_DET (P_miss, P_fa,'r');
title ('Speaker Detection Performance');
hold on;

%find lowest cost point and plot
C_miss = 1;
C_fa = 1;
P_target = 0.5;
Set_DCF(C_miss,C_fa,P_target);
[DCF_opt Popt_miss Popt_fa] = Min_DCF(P_miss,P_fa);
Plot_DET (Popt_miss,Popt_fa,'ko');

