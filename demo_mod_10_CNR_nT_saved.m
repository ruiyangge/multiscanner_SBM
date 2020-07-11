clear;clc;
OriginalPath = pwd;

for a = 1: 10
D_CNR_a = randi([20,150],1,1); %%% CNR levels, this can be a SNR value as well Randomly generate number from 20 to 150
CNR_Mat(a, :) = D_CNR_a %%% save the CNR is the loop
nT_a = randi([30,100],1,1) ; %%% number of subject Randomly generate number from 30 to 100
nT_Mat(a,:)= nT_a
nV = 500; %%% size of the image would be nV*nV
comp_ID = [3 8 9 11 16 17 19 20 21 22 23 25 26 29 30];%%% select 15 components
verbose_display = 0; %%% if you want to see which components you've selected, reset this value to 1

mkdir(['C:\Simulation_Data\Simulation_3\sim_',sprintf('%02d',a)]); %%% make a dictionary to save the simulated data
out_path = [['C:\Simulation_Data\Simulation_3\sim_',sprintf('%02d',a)]]; %%you need to change the out path of your own here
sP = simulation_sMRI_simTB_ryg(nT_a,D_CNR_a,out_path,nV,comp_ID,verbose_display);

simtb_main_ryg_sMRI(sP);
end

save ('nT_Mat') 
save ('CNR_Mat')

%%save CNR_a nT_a