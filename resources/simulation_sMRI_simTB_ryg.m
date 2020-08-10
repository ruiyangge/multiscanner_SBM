function sP = simulation_sMRI_simTB_ryg(nT,D_CNR,out_path,nV,SM_source_ID,verbose_display)
%-------------------------------------------------------------------------------

%% OUTPUT PARAMETERS
%-------------------------------------------------------------------------------
% Directory to save simulation parameters and output
sP.out_path = out_path;
% Prefix for saving output
sP.prefix = 'SimData';
% FLAG to write data in NIFTI format rather than matlab
sP.saveNII_FLAG = 1;
% Option to display output and create figures throughout the simulations
sP.verbose_display = verbose_display;
%-------------------------------------------------------------------------------

%% RANDOMIZATION
%-------------------------------------------------------------------------------
seed = round(sum(100*clock));  % randomizes parameter values
sP.seed = round(sum(100*clock));  % randomizes parameter values
simtb_rand_seed(seed);          % set the seed 
%-------------------------------------------------------------------------------

%% SIMULATION DIMENSIONS
%-------------------------------------------------------------------------------
M  = 1;   % number of subjects    
TR = 2;   % repetition time 
sP.M  = M;   % number of subjects    
sP.nV = nV; % number of voxels; dataset will have [nV x nV] voxels.           
sP.nT = nT; % number of time points           
sP.TR = 2;   % repetition time 

%-------------------------------------------------------------------------------

%% SPATIAL SOURCES
%-------------------------------------------------------------------------------
% Choose the sources. To launch a stand-alone GUI:
% >> simtb_pickSM 
sP.SM_source_ID = SM_source_ID;
sP.nC = length(SM_source_ID);  % number of components            
nC = length(SM_source_ID);  % number of components  
%-------------------------------------------------------------------------------

%% COMPONENT PRESENCE
%-------------------------------------------------------------------------------
% [M x nC] matrix for component presence: 1 if included, 0 otherwise
% For components not of interest there is a 100% chance of component inclusion.
sP.SM_present = (rand(M,nC) < 10);
%-------------------------------------------------------------------------------

%% SPATIAL VARIABILITY
%-------------------------------------------------------------------------------           
% Variability related to differences in spatial location and shape.
sP.SM_translate_x = 1.0*randn(M,nC);  % Translation in x, mean 0, SD 1 voxels.
sP.SM_translate_y = 1.0*randn(M,nC);  % Translation in y, mean 0, SD 1 voxels.
sP.SM_theta       = 1.0*randn(M,nC);  % Rotation, mean 0, SD 1 degree.
%                Note that each 'activation blob' is rotated independently.
sP.SM_spread = 1 + 0.0*randn(M,nC); % Spread < 1 is contraction, spread > 1 is expansion.
%-------------------------------------------------------------------------------

%% TC GENERATION
%-------------------------------------------------------------------------------
% Choose the model for TC generation.  To see defined models:
% >> simtb_countTCmodels
sP.TC_source_type = ones(1,nC);    % convolution with HRF for most components
sP.TC_source_params = cell(M,nC);  % initialize the cell structure
% [tc_dummy, MDESC, P3, PDESC] = simtb_TCsource(1, 1, 1);
%-------------------------------------------------------------------------------

%% EXPERIMENT DESIGN
%-------------------------------------------------------------------------------
% BLOCKS
% No blocks for this experiment
sP.TC_block_n = 0;          % Number of blocks [set = 0 for no block design]
TC_block_n = 1;          % Number of blocks [set = 0 for no block design]
% Note that if TC_block_n = 0 the rest of these parameters are irrelevant
sP.TC_block_same_FLAG = 1;  % 1 = block structure same for all subjects
                         % 0 = otherwise order will be randomized
sP.TC_block_length = 5;    % length of each block (in samples)
sP.TC_block_ISI    = 5;    % length of OFF inter-stimulus-intervals (in samples)
sP.TC_block_amp    = zeros(nC, TC_block_n);
sP.TC_block_amp(15,1) = 1.5;   % [nC x TC_block_n] matrix of task-modulation amplitudes %%%%%%%%%%????????????


% EVENTS
% No events for this experiment
sP.TC_event_n = 0;          % Number of event types (0 for no event-related design)
                         % 1: standard tone
                         % 2: target tone
                         % 3: novel tone
                         % 4: 'spike' events in CSF (not related to task)
sP.TC_event_same_FLAG = 0;  % 1=event timing will be the same for all subjects
sP.TC_event_prob = []; 
sP.TC_event_amp = []; 

%-------------------------------------------------------------------------------

%% UNIQUE EVENTS
%-------------------------------------------------------------------------------
sP.TC_unique_FLAG = 1; % 1 = include unique events
sP.TC_unique_prob = 0.2*ones(1,nC); % [1 x nC] prob of unique event at each TR
sP.TC_unique_amp  = 1*ones(M,nC);     % [M x nC] matrix of amplitude of unique events
%-------------------------------------------------------------------------------

%% DATASET BASELINE                                 
%-------------------------------------------------------------------------------
% [1 x M] vector of baseline signal intensity for each subject
sP.D_baseline = 1000*ones(1,M); % [1 x M] vector of baseline signal intensity
%-------------------------------------------------------------------------------

%% TISSUE TYPES
%-------------------------------------------------------------------------------
% FLAG to include different tissue types (distinct baselines in the data)
sP.D_TT_FLAG = 0;                    % if 0, baseline intensity is constant 
sP.D_TT_level = [0.3, 0.7, 1, 1.5]; % TT fractional intensities
% To see/modify definitions for tissue profiles:
% >> edit simtb_SMsource.m
%-------------------------------------------------------------------------------

%% PEAK-TO-PEAK PERCENT SIGNAL CHANGE of the simulated components 
%-------------------------------------------------------------------------------
% sP.D_pSC = 3 + 0.25*randn(M,nC);   % [M x nC] matrix of percent signal changes 
sP.D_pSC = 2 + 0.5*randn(M,nC);   % [M x nC] matrix of percent signal changes 
%-------------------------------------------------------------------------------

%% NOISE
%-------------------------------------------------------------------------------
sP.D_noise_FLAG = 1;               % FLAG to add rician noise to the data
sP.D_CNR = D_CNR * ones(1,M);
%-------------------------------------------------------------------------------

%% MOTION
% No motion for this experiment
%--------------------------------------------------------------------------
sP.D_motion_FLAG = 0;              % 1=motion, 0=no motion
sP.D_motion_TRANSmax = 0;       % max translation, proportion of entire image
sP.D_motion_ROTmax = 1;            % max rotation, in degrees
sP.D_motion_deviates = ones(M,3)*0.1;  % proportion of max each subject moves
%-------------------------------------------------------------------------------
% END of parameter definitions

