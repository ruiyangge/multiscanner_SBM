clear;clc;
OriginalPath = pwd;

D_CNR = 100; %%% CNR levels, this can be a SNR value as well
nT = 50; %%% number of subject
nV = 500; %%% size of the image would be nV*nV
comp_ID = [3 8 9 11 16 17 19 20 21 22 23 25 26 29 30];%%% select 15 components
verbose_display = 0; %%% if you want to see which components you've selected, reset this value to 1

mkdir(['D:\software\simtb_v18_ryg\site_1']); %%% make a dictionary to save the simulated data
out_path = ['D:\software\simtb_v18_ryg\site_1'];
sP = simulation_sMRI_simTB_ryg(nT,D_CNR,out_path,nV,comp_ID,verbose_display);
simtb_main_ryg_sMRI(sP);

