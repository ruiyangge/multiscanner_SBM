function compare_spatialMaps(order1,order2)


% clear;clc;
OriginalPath = pwd;

%% strategy 1, each dataset into a single session
cd('D:\SBM_simulation\data_simTB\20200711\ICAoutputs\ICA_strategy1_16comps');
order = order1;
load('ica_ica.mat')
icasig = zscore(icasig');
icasig = icasig';
ic_strategy1_group = icasig(order,:);

%% strategy 2, concatenating all data into a single session
cd('D:\SBM_simulation\data_simTB\20200711\ICAoutputs\ICA_strategy2_16comps');
order = order2;
load('ica_ica.mat')
icasig = zscore(icasig');
icasig = icasig';
ic_strategy2_group = icasig(order,:);


cd('D:\SBM_simulation\data_simTB\20200711\simData\sim_GroundTruth');
load template_binary;

thre = [0.1:0.1:10];
for ijk = 1:length(thre)
    
%     groundTruth_ic_binary = template_binary([1 3:end],:);
    groundTruth_ic_binary = template_binary;
    ic_strategy1_group_binary = ic_strategy1_group > thre(ijk);
    ic_strategy2_group_binary = ic_strategy2_group > thre(ijk);
    for i=1:16
        
        Dice_strategy1_group(i,ijk) = dice(double(ic_strategy1_group_binary(i,:)),groundTruth_ic_binary(i,:));
        Dice_strategy2_group(i,ijk) = dice(double(ic_strategy2_group_binary(i,:)),groundTruth_ic_binary(i,:));
    
    end
end
for i = 1:16
    
    area_strategy1_group(i,1) = trapz(thre,Dice_strategy1_group(i,:));
    area_strategy2_group(i,1) = trapz(thre,Dice_strategy2_group(i,:));
    
end

%% group-level results
figure;
similarity_mean = mean(Dice_strategy1_group);
similarity_std = std(Dice_strategy1_group)'/sqrt(15);
hold on;errorbar(similarity_mean,similarity_std,'-o','Color',[1.00,0.41,0.16]);
similarity_mean = mean(Dice_strategy2_group);
similarity_std = std(Dice_strategy2_group)'/sqrt(15);
hold on;errorbar(similarity_mean,similarity_std,'-o','Color',[0.00,0.45,0.74]);
xticks([1 100])
xticklabels({'0.1','10'})

cd(OriginalPath);


