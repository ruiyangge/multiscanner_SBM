function compare_loadingVectors(order1,order2)


% clear;clc;
OriginalPath = pwd;

cd('D:\SBM_simulation\data_simTB\20200711\simData');
load nT_Mat_15T;
nT_all = nT_Mat;
load nT_Mat_30T;
nT_all = [nT_all;nT_Mat];

%% ground truth of loading vectors
for i = 1:10
    
    load(['D:\SBM_simulation\data_simTB\20200711\simData\sim_',sprintf('%02d',i),'\SimData_subject_001_SIM.mat']);
    tc_template{i} = TC;
    
end


%% first 5 sites
%% strategy 1, each dataset into a single session
cd('D:\SBM_simulation\data_simTB\20200711\ICAoutputs\ICA_strategy1_16comps');
order = order1([1 3:end]);
for i = 1:5
    
    load(['ica_ica_c',sprintf('%d',i),'-1.mat']);
    tc_strategy1_individual{i} = tc(:,order);
    
end
%% strategy 2, concatenating all data into a single session
cd('D:\SBM_simulation\data_simTB\20200711\ICAoutputs\ICA_strategy2_16comps');
order = order2([1 3:end]);
load('ica_ica_c1-1.mat')
tc_strategy2 = tc(:,order);
for i = 1:5
    
        tc_strategy2_individual{i} = tc_strategy2(sum(nT_all(1:i-1))+1:sum(nT_all(1:i)),:);
    
end
%% correlation between loading vectors of ICA estimates and templates
for i = 1:5
    
    [r,p] = corr(tc_template{1,i},tc_strategy1_individual{1,i});
    r_strategy1(:,i) = diag(r);
    [r,p] = corr(tc_template{1,i},tc_strategy2_individual{1,i});
    r_strategy2(:,i) = diag(r);
    
end

figure;
   
r1 = reshape(r_strategy1,75,1);
r2 = reshape(r_strategy2,75,1);
subplot(2,1,1)
r_mean = [mean(r1) mean(r2)];
r_std = [std(r1) std(r2)]/sqrt(75);
errorbar(r_mean,r_std,'.');   
hold on;bar(r_mean);  
title('1-5 sites');
xticks([1 2])
xticklabels({'strategy 1','strategy 2'})


cd(OriginalPath);


%% second 10 components
%% strategy 1, each dataset into a single session
cd('D:\SBM_simulation\data_simTB\20200711\ICAoutputs\ICA_strategy1_16comps');
order = order1([1:4 6:end]);
for i = 1:5
    
    load(['ica_ica_c',sprintf('%d',i+5),'-1.mat']);
    tc_strategy1_individual{i} = tc(:,order);
    
end

%% strategy 2, concatenating all data into a single session
cd('D:\SBM_simulation\data_simTB\20200711\ICAoutputs\ICA_strategy2_16comps');
order = order2([1:4 6:end]);
load('ica_ica_c1-1.mat')
tc_strategy2 = tc(:,order);
for i = 6:10
    
    j = i-5;
    tc_strategy2_individual{j} = tc_strategy2(sum(nT_all(1:i-1))+1:sum(nT_all(1:i)),:);
    
end

%% correlation between loading vectors of ICA estimates and templates
for i = 1:5
    
    [r,p] = corr(tc_template{1,i+5},tc_strategy1_individual{1,i});
    r_strategy1(:,i) = diag(r);
    [r,p] = corr(tc_template{1,i+5},tc_strategy2_individual{1,i});
    r_strategy2(:,i) = diag(r);
    
end

r1 = reshape(r_strategy1,75,1);
r2 = reshape(r_strategy2,75,1);
subplot(2,1,2);
r_mean = [mean(r1) mean(r2)];
r_std = [std(r1) std(r2)]/sqrt(75);
errorbar(r_mean,r_std,'.');   
hold on;bar(r_mean);
title('6-10 sites');
xticks([1 2])
xticklabels({'strategy 1','strategy 2'})


cd(OriginalPath);
