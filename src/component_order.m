clear;clc;
OriginalPath = pwd;

% cd('D:\SBM_simulation\data_simTB\20200711\simData\sim_01');
% Mask0 = 'SimData_subject_001_DATA.nii';
% V0 = spm_vol(Mask0);
% Data0 = spm_read_vols(V0);
% index = find(Data0(:,:,:,1)>500);

%% template
%%%%%%%%%%%%%%%%%% spatial templates
cd('D:\SBM_simulation\data_simTB\20200711\simData\sim_GroundTruth');
load template_binary;
%%%%%%%%%%%%%%%%%% loading vector templates
for i = 1:10
    
    load(['D:\SBM_simulation\data_simTB\20200711\simData\sim_',sprintf('%02d',i),'\SimData_subject_001_SIM.mat']);
    tc_template{i} = TC;
    
end

%% strategy 1, each dataset into a single session
%%%%%%%%%%%%%%%%%% spatial maps
cd('D:\SBM_simulation\data_simTB\20200711\ICAoutputs\ICA_strategy1_16comps');
load('ica_ica.mat')
icasig = zscore(icasig');
icasig = icasig';
ic_strategy1_group = icasig;
for i = 1:10
    
    load(['ica_ica_c',sprintf('%d',i),'-1.mat']);
    ic_strategy1(:,:,i) = ic;
    
end
ic_strategy1_group_binary = ic_strategy1_group > 2.5;
%%%%%%%%%%%%%%%%%% loading vectors
for i = 1:10
    
    load(['ica_ica_c',sprintf('%d',i),'-1.mat']);
    lv_strategy1_individual{i} = tc;
    
end

%% strategy 2, all datasets into a single session
%%%%%%%%%%%%%%%%%% spatial maps
cd('D:\SBM_simulation\data_simTB\20200711\ICAoutputs\ICA_strategy2_16comps');
load('ica_ica.mat')
icasig = zscore(icasig');
icasig = icasig';
ic_strategy2_group = icasig;

%%%%%%%%%%%%%%%%%% loading vectors
cd('D:\SBM_simulation\data_simTB\20200711\simData');
load nT_Mat_15T;
nT_all = nT_Mat;
load nT_Mat_30T;
nT_all = [nT_all;nT_Mat];
cd('D:\SBM_simulation\data_simTB\20200711\ICAoutputs\ICA_strategy2_16comps');
load('ica_ica_c1-1.mat')
lv_strategy2 = tc;
for i = 1:10
       
    lv_strategy2_individual{i} = lv_strategy2(sum(nT_all(1:i-1))+1:sum(nT_all(1:i)),:);
    
end


%% dice of spatial maps
for i = 1:16
    for j = 1:16
        
        ic_strategy2_group_binary = ic_strategy2_group > 1.96;
        [dice_strategy1(i,j)] = dice(double(ic_strategy1_group_binary(i,:)),template_binary(j,:));
        [dice_strategy2(i,j)] = dice(double(ic_strategy2_group_binary(i,:)),template_binary(j,:));
        
    end
end
for i=1:16
    
    index_ = find(dice_strategy1(:,i)==max(dice_strategy1(:,i)));
    order_strategy1(i,1) = index_;
    index_ = find(dice_strategy2(:,i)==max(dice_strategy2(:,i)));
    order_strategy2(i,1) = index_;

end
order_strategy1=order_strategy1'
order_strategy2=order_strategy2'
