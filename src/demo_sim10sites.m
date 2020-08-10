clear;clc;
OriginalPath = pwd;


datapath='data_simTB/20200711/simData';
addpath(genpath(fullfile(pwd,"../")));

%% 1.5T simulation
% rng('default');
% rng(10);
D_SNR = randi([40,110],100,1)+randn(100,1);
for a = 1:5
    
    D_SNR_a = D_SNR(a); %%% SNR levels, this can be a CNR value as well Randomly generate number from 40 to 45
    SNR_Mat(a, :) = D_SNR_a; %%% save the SNR is the loop
%     rng('default');rng(a);
    nT_a = randi([50,100],1,1) ; %%% number of subject Randomly generate number from 30 to 100
    nT_Mat(a,:)= nT_a;
    nV = 300; %%% size of the image would be nV*nV
    comp_ID = [3 8 9 11 16 17 19 20 21 22 23 25 26 29 30];%%% select 15 components
    verbose_display = 0; %%% if you want to see which components you've selected, reset this value to 1

    out_path = fullfile(datapath,sprintf('sim_%02d',a));
    mkdir(out_path);
    sP = simulation_sMRI_simTB_ryg(nT_a,D_SNR_a,out_path,nV,comp_ID,verbose_display);
    simtb_main_ryg_sMRI(sP);
    
end

save(fullfile(datapath,"SNR_Mat_15T"), "SNR_Mat");
save(fullfile(datapath,"nT_Mat_15T"), "nT_Mat");

%% 3.0T simulation
% rng('default');
% rng(1000);
D_SNR = randi([40,110],100,1)+randn(100,1);
for a = 6:10
    
    D_SNR_a = D_SNR(a); %%% SNR levels, this can be a CNR value as well Randomly generate number from 40 to 45
    SNR_Mat(a, :) = D_SNR_a; %%% save the SNR is the loop
%     rng('default');rng(a+5);
    nT_a = randi([50,100],1,1) ; %%% number of subject Randomly generate number from 30 to 100
    nT_Mat(a,:)= nT_a;
    nV = 300; %%% size of the image would be nV*nV
    comp_ID = [3 7 8 9 16 17 19 20 21 22 23 25 26 29 30];%%% select 15 components
    verbose_display = 0; %%% if you want to see which components you've selected, reset this value to 1

    out_path = fullfile(datapath,sprintf('sim_%02d',a));
    mkdir(out_path);
    
    sP = simulation_sMRI_simTB_ryg(nT_a,D_SNR_a,out_path,nV,comp_ID,verbose_display);
    simtb_main_ryg_sMRI(sP);
    
end

save(fullfile(datapath,"SNR_Mat_30T"), "SNR_Mat");
save(fullfile(datapath,"nT_Mat_30T"), "nT_Mat");

%% generate template
SNR_Mat = 1000; %%% save the SNR is the loop
% rng('default');
nT_Mat = 20; %%% number of subject Randomly generate number from 30 to 100
nV = 300; %%% size of the image would be nV*nV
comp_ID = [3 7 8 9 11 16 17 19 20 21 22 23 25 26 29 30];%%% select 16 components
verbose_display = 0; %%% if you want to see which components you've selected, reset this value to 1

out_path = fullfile(datapath,"sim_GroundTruth");
mkdir(out_path); 

sP = simulation_sMRI_simTB_template_ryg(nT_Mat,SNR_Mat,out_path,nV,comp_ID,verbose_display);
simtb_main_ryg_sMRI(sP);

load('SimData_subject_001_SIM.mat')
index = find(SM(1,:)~=0);
for i=1:16
    a=SM(i,index);
    b=zscore(a);
    c=zeros(1,90000);
    c(index)=b;
    d = c>1.96;
    SM(i,:) = d;
end
template_binary = SM(:,index);
save template_binary template_binary




