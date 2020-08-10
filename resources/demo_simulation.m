clear;clc;
OriginalPath = pwd;

datapath = 'simData';
% addpath(genpath(fullfile(pwd,"../")));
mkdir([OriginalPath,'/',datapath]);

%% first 10 simulations
D_SNR = randi([40,110],100,1)+randn(100,1);
for a = 1:10
    
    D_SNR_a = D_SNR(a); %%% SNR levels, this can be a CNR value as well Randomly generate number from 40 to 45
    SNR_Mat(a, :) = D_SNR_a; %%% save the SNR is the loop
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

save(fullfile(datapath,"SNR_Mat_1st"), "SNR_Mat");
save(fullfile(datapath,"nT_Mat_1st"), "nT_Mat");

%% 2nd 10 simulations
D_SNR = randi([40,110],100,1)+randn(100,1);
for a = 11:20
    
    D_SNR_a = D_SNR(a); %%% SNR levels, this can be a CNR value as well Randomly generate number from 40 to 45
    SNR_Mat(a, :) = D_SNR_a; %%% save the SNR is the loop
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

save(fullfile(datapath,"SNR_Mat_2nd"), "SNR_Mat");
save(fullfile(datapath,"nT_Mat_2nd"), "nT_Mat");

