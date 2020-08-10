function varargout = simtb_params(P)
%   simtb_params()  - Provides information on all simulation parameters
%
%   Usage:
%    >> SIMULATION_PARAMS = simtb_params;
%    >> ALL_PARAMETERS_HELP = simtb_params('all');
%    >> simtb_params(P);
%    >> [PARAMETER_HELP, DESC, DTYPE, EXAMPLE, LABEL, DEFAULT] = simtb_params(P);
%
%   INPUTS: (OPTIONAL)
%   no input  =   Returns a list of simtb parameters
%   'all'     =   Displays help for all parameters
%   P         =   A string, displays help for any parameters with names matching P.
%
%   OUTPUTS: (OPTIONAL)
%   SIMULATION_PARAMS  = cell array with list of parameters (returned if no input)
%   PARAMETER_HELP     = string, full help for parameter P [DESC, DTYPE, EXAMPLE, DEFAULT]
%     DESC             = string, description of P
%     DTYPE            = string, data type of P
%     EXAMPLE          = string, example of how to modify P
%     LABEL            = string, short description of P for GUI
%     DEFAULT          = string, default value used in simtb_create_sP and GUI
%
%   see also:  simtb_create_sP(), simtb_checkparams()

Pdescription = [];

% no input, lists just the parameter names
if nargin == 0
    sP = simtb_create_sP;
    Pdescription = fieldnames(sP);
    varargout{1} = Pdescription;
    return
end

% 'all', lists all parameters with their descriptions
if strcmpi(P,'all')
    P = '';
end

%% Get information on the parameter
thisparam = 'M';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Number of subjects.';
    DESC = 'Number of subjects.';
    DTYPE = 'A positive integer.';
    DEFAULT = '10';
    EXAMPLE = 'M = 30; %% Simulations will include 30 subjects';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'nC';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Number of components.';
    DESC = 'Number of components.';
    DTYPE = 'A positive integer.';
    count = simtb_countSM;
    s = sprintf('Number of defined sources: %d', count);
    DEFAULT = sprintf('%s',s);
    EXAMPLE = 'nC = 12; %% Datasets will have 12 components';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'nV';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Side length of 2-D square image.';
    DESC = 'Side length of 2-D square image; full image will have [nV x nV] voxels.';
    DTYPE = 'A positive integer.';
    DEFAULT = '100';
    EXAMPLE = 'nV = 100; %% Datasets will have [100 x 100] voxels.';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'nT';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Number of time points (TRs).';
    DESC = 'Number of time points (TRs).';
    DTYPE = 'A positive integer.';
    DEFAULT = '150';
    EXAMPLE = 'nT = 150; %% Datasets will have 150 time points.';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'TR';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Repetition time, in seconds.';
    DESC = 'Repetition time, in seconds.';
    DTYPE = 'Positive real.';
    DEFAULT = '2';
    EXAMPLE = 'TR = 2; %% Repetition time of 2 seconds.';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'SM_source_ID';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Select component SMs.';
    DESC = ['[1 x nC] vector of IDs for spatial sources used to generate SMs. ',...
           'You can select defined sources using the GUI simtb_pickSM() or define your own in simtb_SMsource().'];
    DTYPE = 'Positive integers.';
    DEFAULT = '1:nC';
    EXAMPLE = ['SM_source_ID = [2 4 5 10 13 15 19 20 21 22 23 27];\n',...
              '%% SMs will be generated from these 12 sources.'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'TC_source_type';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'BOLD generation models.';
    DESC = ['[1 x nC] vector of model types used to generation of TCs. ',...
        'An example of a model is convolution of a time course with a haemodynamic response function (HRF). ',...
        'You can learn about the defined models with simtb_countTCmodels() or define your own model in simtb_TCsource().'];
    DTYPE = 'Positive integers.';
    DEFAULT = 'ones(1,nC)';
    EXAMPLE = ['TC_source_type = ones(1,nC); TC_source_type(6) = 3;\n',...
        '%% TCs for most components will be generated by model 1;\n'...
        '%% TCs for component 6 will be generated with model 3.'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'TC_source_params';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Model parameters.';
    DESC = ['{M,nC} cell array of parameters for generating TCs with the selected models. ',...
        'An example is parameters defining a haemodynamic response function (HRF). ',...
        'Set TC_source_params = cell(M,nC) to use the default parameters. '...
        'Use simtb_countTCmodels() to learn about the necessary parameters, which may be a different length for each model.'];
    DTYPE = 'Real.';
    DEFAULT = 'cell(M,nC)';
    EXAMPLE = ['for sub = 1:M\n',...
        '\tfor c = 1:nC\n',...
        '\t\tTC_source_params{sub,c} = [5, 13, 1, 1, 5, 0, 24];\n',...
        '\tend\n',...
        '\tTC_source_params{sub,6} = [1, 5, .8, 1, 3, 0, 20];\n',...
        'end\n', ...
        '%% TC generation models are the same for all subjects;\n'...
        '%% component 6 has a model distinct from all other components.'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'TC_block_n';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'How many block conditions?';
    DESC = ['Number of different block conditions in a block design.\n',...
        'Set TC_block_n = 0 for no block design.'];
    DTYPE = 'A positive integer.';
    DEFAULT = '0';
    EXAMPLE = ['TC_block_n = 2; %% Experiment with 2 block conditions.\n', ...
        '%% In an Visual Contrast paradigm, these might designate SAD and HAPPY faces.'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'TC_block_same_FLAG';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Block timing common for subjects?';
    DESC = 'FLAG to make block timing the same (1) or different (0) across subjects.';
    DTYPE = 'Binary (1 = yes, 0 = no).';
    DEFAULT = '0';
    EXAMPLE = 'TC_block_same_FLAG = 1; %% Timing of blocks will be the same across subjects.';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'TC_block_length';
if strmatch(upper(P), upper(thisparam))
    LABEL = sprintf('Block length (in TRs).');
    DESC = sprintf('Length of each block (in TRs).');
    DTYPE = 'A positive integer.';
    DEFAULT = '0';
    EXAMPLE = 'TC_block_length = 15; %% Each block will be 15 TRs long.';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'TC_block_ISI';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Block OFF length (in TRs).';
    DESC = sprintf('Interstimulus interval is the length of the OFF block, in TRs.');
    DTYPE = 'A positive integer.';
    DEFAULT = '0';
    EXAMPLE = 'TC_block_ISI = 10; %% Blocks will be separated by 10 TRs.';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'TC_block_amp';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Block amplitude for each component.';
    DESC = ['[nC x TC_block_n] matrix of task-modulation amplitudes.\n',...
        'Units are arbitrary but should be relative to experiment and/or unique event amplitudes.'];
    DTYPE = 'Real.';
    DEFAULT = '[]';
    EXAMPLE = ['TC_block_amp = ones(nC,TC_block_n);\nTC_block_amp(:,2) = -0.5*TC_block_amp(:,2);\n', ...
        'TC_block_amp([1 5 8],:) = 0;\n', ...
        '%% Most components have an amplitude of 1 for block type 1,\n', ...
        '%% and an amplitude of -0.5 for block type 2.\n', ...
        '%% Components 1, 5, and 8 have no block-related activity.'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'TC_event_n';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'How many event trial types?';
    DESC = ['Number of different types of events for an event-related design experiment.\n',...
        'Set TC_event_n = 0 for no event-related design.'];
    DTYPE = 'A positive integer.';
    DEFAULT = '0';
    EXAMPLE = ['TC_event_n = 3; %% Experiment with 3 different types of events.\n',...
        '%% In an Oddball paradigm, these might be STANDARD, NOVEL and TARGET stimuli.'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'TC_event_same_FLAG';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Event timing common for subjects?';
    DESC = 'FLAG to make event structure timing the same (1) or different (0) across subjects.';
    DTYPE = 'Binary (1 = yes, 0 = no).';
    DEFAULT = '0';
    EXAMPLE = 'TC_event_same_FLAG = 1; %% Timing events will be the same across subjects.';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'TC_event_amp';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Event amplitude for each component.';
    DESC = ['[nC x TC_event_n] matrix of task-modulation amplitudes.\n',...
        'Units are arbitrary but should be relative to block and/or unique event amplitudes.'];
    DTYPE = 'Real.';
    DEFAULT = '[]';
    EXAMPLE = ['TC_event_amp = 2*ones(nC,TC_event_n);\nTC_event_amp(:,1) = 1;\n', ...
        'TC_event_amp(2,:) = -TC_event_amp(2,:);\nTC_event_amp(5,:) = 0;\n', ...
        '%% Most events have amplitude 2 and event type 1 has amplitude 1.\n', ...
        '%% Component 2 activity decreases with events.\n%% Component 5 has no event-related activity.'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'TC_event_prob';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Event probability at each TR.';
    DESC = ['[1 x TC_event_n] vector of probabilities that an event occurs at each TR.\n', ...
        'The sum of TC_event_prob (i.e., the probability of any event) must be <= 1.'];
    DTYPE = 'Probabilities ([0,1]).';
    DEFAULT = '[]';
    EXAMPLE = ['TC_event_prob = 0.2*ones(1,TC_event_n); TC_event_prob(2) = 0.05;\n', ...
        '%% Most events will occur (on average) every 5 TRs.\n', ...
        '%% Event type 2 will occur more rarely (on average once every 20 TRs).'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'TC_unique_FLAG';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Include unique events?';
    DESC =  ['FLAG to include (1) or exclude (0) random events that are unique to each TC.\n',...
        'If there is no experimental design (TC_event_n = 0 and TC_block_n = 0),\n', ...
        'TC_unique_FLAG should be 1 so that component TCs are not completely flat.'];
    DTYPE = 'Binary (1 = yes, 0 = no).';
    DEFAULT = '1';
    EXAMPLE = 'TC_unique_FLAG = 1; %% TCs will have random and unique events.';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'TC_unique_prob';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Unique event probability at each TR.';
    DESC =  '[M x nC] vector of probabilities that an event occurs at each TR.';
    DTYPE = 'Probabilities ([0,1]).';
    DEFAULT = '0.5*ones(M,nC)';
    EXAMPLE = 'TC_unique_prob = 0.2*ones(M,nC); %% Unique events occur on average every 5 TRs.';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'TC_unique_amp';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Unique event amplitude.';
    DESC = ['[M x nC] matrix of amplitude of unique events. ',...
        'Units are arbitrary but should be relative to designed (block or event) amplitudes. ',...
        'If there is no experimental design (TC_event_n = 0 and TC_block_n = 0), TC_unique_amp is irrelevant.'];
    DTYPE = 'Real.';
    DEFAULT = 'ones(M,nC)';
    EXAMPLE = 'TC_unique_amp = ones(M,nC);\n%% Unique events for all subjects and components will have amplitude 1.';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'SM_present';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Component presence/absence.';
    DESC = ['[M x nC] matrix indicating whether component is present (1) or absent (0) from the subject''s dataset.',...
           ' Note that if a component is absent, any deviations in in baseline intensity associated with that component will also be absent.',... 
           ' To retain alterations in the baseline intensity map without component activation, set D_pSC(subject, component) = 0;.'];
    DTYPE = 'Binary (1 = yes, 0 = no).';
    DEFAULT = 'ones(M,nC)';
    EXAMPLE = ['SM_present = ones(M, nC); SM_present([1,3,6], 2) = 0; \n',...
        '%% Most components are present for all subjects.\n%% Component 2 is absent for subjects 1, 3 and 6.'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'SM_translate_x';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'SM x-translation (in voxels).';
    DESC = '[M x nC] matrix of translations in the x-direction for component SMs, in units of voxels.';
    DTYPE = 'Real.';
    DEFAULT = 'zeros(M,nC)';
    EXAMPLE = ['SM_translate_x = zeros(M, nC);\nSM_translate_x(1:5, 5) = -0.05*nV;\nSM_translate_x(6:10, 5) = 5;\n',...
        '%% Most components are not horizontally translated.\n',...
        '%% For subjects 1-5, component 5 is translated left by 5%% of the image size.\n',...
        '%% For subjects 6-10, component 5 is translated right by 5 voxels.'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'SM_translate_y';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'SM y-translation (in voxels).';
    DESC = '[M x nC] matrix of translations in the y-direction for component SMs, in units of voxels.';
    DTYPE = 'Real.';
    DEFAULT = 'zeros(M,nC)';
    EXAMPLE = ['SM_translate_y = zeros(M, nC);\nSM_translate_y(1:5, 7) = -0.05*nV;\nSM_translate_y(6:10, 7) = 5;\n',...
        '%% Most components are not vertically translated.\n',...
        '%% For subjects 1-5, component 7 is translated down by 5%% of the image size.\n',...
        '%% For subjects 6-10, component 7 is translated up by 5 voxels.'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end


thisparam = 'SM_theta';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'SM rotation (in degrees).';
    DESC = '[M x nC] matrix of rotation angles for component SMs, in degrees. Positive degrees denote clockwise rotation.';
    DTYPE = 'Real.';
    DEFAULT = 'zeros(M,nC)';
    EXAMPLE = ['SM_theta = zeros(M, nC); SM_theta(1:5, 9) = -45; SM_theta(6:10, 9) = 45;\n',...
        '%% Most components are not rotated.\n',...
        '%% For subjects 1-5, component 9 is rotated counter-clockwise 45 degrees.\n',...
        '%% For subjects 6-10, component 9 is rotated clockwise 45 degrees.'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'SM_spread';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'SM size.';
    DESC = ['[M x nC] matrix of spatial magnification factors. ',...
        'Values greater than 1 increase the spatial spread of the SM, values less than 1 contract the SM.'];
    DTYPE = 'Positive real.';
    DEFAULT = 'ones(M,nC)';
    EXAMPLE = ['SM_spread = ones(M, nC); SM_spread(4, :) = 0.9; SM_spread(5, :) = 1.1;\n',...
        '%% Most component SMs are not enlarged or contracted.\n',...
        '%% For subject 4, all components are slightly contracted.\n',...
        '%% For subject 5, all componetns are slightly enlarged.'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'D_baseline';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Baseline intensities for subjects.';
    DESC = '[1 x M] vector of baseline signal intensities for subjects.';
    DTYPE = 'Positive real.';
    DEFAULT = '800*ones(1,M)';
    EXAMPLE = ['D_baseline = 1000+100*randn(1,M);\n',...
        '%% Baselines are normally distributed across subjects\n%% with a mean of 1000 and standard deviation of 100.'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'D_TT_FLAG';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Use distinct tissue types baselines?';
    DESC = ['FLAG to include (1) or exclude (0) distinct baselines (i.e., tissue types). ',...
        'You can designate the tissue types of different components in simtb_SMsource().'];
    DTYPE = 'Binary (1 = yes, 0 = no).';
    DEFAULT = '0';
    EXAMPLE = 'D_baseline = 1; %% Model will include regions with distinct baselines';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'D_TT_level';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Tissue type level.';
    DESC = ['[1 x TTn] matrix of fractional intensities for each tissue type (TT). ',...
        'The primary TT should have a D_TT_level of 1 (which will correspond to the intensity value in D_baseline); ',...
        'D_TT_levels of the other TTs indicate a fraction (or proportion) of this value. '...
        'TTn is the number of defined tissue types which you can determine from simtb_SMsource(), ',...
        'or using the helper function simtb_countTT().'];
    DTYPE = 'Positive real.';
    [TT_count, TT_levels] = simtb_countTT;
    s = sprintf('Default TT levels: [%s]', num2str(TT_levels, '%0.1f, '));
    DEFAULT = sprintf('%s%s',s(1:end-2),s(end));
    EXAMPLE = ['D_TT_level = [0.3, 0.7, 1, 1.5];\n',...
        '%% TT = 1 has a very low relative baseline            (e.g., signal dropout)\n',...
        '%% TT = 2 has a baseline less than the primary TT     (e.g., White Matter)\n',...
        '%% TT = 3 is the primary TT                           (e.g., Gray Matter)\n',...
        '%% TT = 4 has a baseline greater than the primary TT  (e.g., CSF)'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'D_pSC';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Percent signal change for subject components.';
    DESC = '[M x nC] matrix of percent signal changes (pSC) for component activations, in units of percentage points.';
    DTYPE = 'Percentages ([0,100]).';
    DEFAULT = 'ones(M,nC)';
    EXAMPLE = ['D_pSC = 2*ones(M, nC); D_pSC(:,8) = 6; D_pSC(:,6) = 0.1;\n',...
        '%% Most components have a 2%% signal change.\n', ...
        '%% Component 8 has a 6%% signal change; component 6 has a 0.1%% signal change.'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'D_noise_FLAG';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Add Rician noise?';
    DESC = 'FLAG to include (1) or exclude (0) the addition of Rician noise to the datasets.';
    DTYPE = 'Binary (1 = yes, 0 = no).';
    DEFAULT = '1';
    EXAMPLE = 'D_noise_FLAG = 1; %% Rician noise will be added to the datasets.';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'D_CNR';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Contrast-to-noise ratio.';
    DESC = ['[1 x M] vector of contrast-to-noise (CNR) ratios. ',...
        'CNR is defined as the peak-to-peak range of the component activation, ',...
        'divided by the peak-to-peak range of the added Rician noise.'];
    DTYPE = 'Positive real.';
    DEFAULT = 'ones(1,M)';
    EXAMPLE = ['D_CNR = linspace(0.5, 2, M);\n',...
        '%% CNR ranges linearly from 0.5 for subject 1 (most noise)\n%% to 2 for subject M (least noise).'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'D_motion_FLAG';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Add motion?';
    DESC = 'FLAG to include (1) or exclude (0) simulated motion of datasets.';
    DTYPE = 'Binary (1 = yes, 0 = no).';
    DEFAULT = '0';
    EXAMPLE = 'D_motion_FLAG = 1; %% Data will be rotated and/or translated over time.';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'D_motion_TRANSmax';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Max translation (proportion of image length).';
    DESC = 'Maximum possible image translation, as a proportion of the image length.';
    DTYPE = 'A proportion ([0,1]).';
    DEFAULT = '0';
    EXAMPLE = 'D_motion_TRANSmax = 0.05;\n%% Data will be maximally translated by 5%% of the image size.';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'D_motion_ROTmax';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Max rotation (degrees).';
    DESC = 'Maximum possible image rotation, in degrees.';
    DTYPE = 'Real.';
    DEFAULT = '0';
    EXAMPLE = 'D_motion_ROTmax = 5; %% Data will be maximally rotated by 5 degrees.';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'D_motion_deviates';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Motion deviates, relative to Max values.';
    DESC = ['[M x 3] matrix of motion deviates, as proportions of the maximum motion.\n',...
        'Column 1 refers to x-translation for each subject,\n',...
        'Column 2 refers to y-translation for each subject,\n',...
        'and Column 3 refers to rotation for each subject.\n',...
        'See simtb_makeMotParams() for info on motion parameter generation.'];
    DTYPE = 'A proportion ([0,1]).';
    DEFAULT = 'zeros(M,3)';
    EXAMPLE = ['D_motion_deviates(:,1) = linspace(0, 1, M)'';\n',...
        'D_motion_deviates(:,2) = linspace(0, 1, M)'';\n',...
        'D_motion_deviates(:,1) = 0.8*ones(1, M)'';\n',...
        '%% Translation in x and y range linearly from 0 for subject 1\n',...
        '%% to maximal for subject M (as defined by D_motion_TRANSmax).\n',...
        '%% The degree of rotational motion is the same for all subjects.'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'saveNII_FLAG';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Save in NIFTI format?';
    DESC = ['FLAG to save datasets in nifti format (.nii) rather than .mat format.\n',...
           'If saveNII_FLAG = 1, SPM functions must be on the matlab path.\n',...
           'To download SPM: http://www.fil.ion.ucl.ac.uk/spm/.'];
    DTYPE = 'Binary (1 = yes, 0 = no).';
    DEFAULT = '0';
    EXAMPLE = ['saveNII_FLAG = 1; \n'...,
               '%% Datasets will be saved in nifti format, rather than .mat format.'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'verbose_display';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Display figures throughout simulation?';
    DESC = ['FLAG to display simulation parameters and simulation output.\n'...
           'Figures will be saved as .fig and .jpg files.'];
    DTYPE = 'Binary (1 = yes, 0 = no).';
    DEFAULT = '1';
    EXAMPLE = 'verbose_display = 1; %% Figures will be displayed throughout the simulation.';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'seed';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Random seed.';
    DESC = 'Seed used to set the state of the random number generator.  Can be used to exactly reproduce simulations.';
    DTYPE = 'A positive integer.';
    DEFAULT = 'round(sum(100*clock))';
    EXAMPLE = ['seed = round(sum(100*clock)); \n',...
              '%% Seed is randomized each time the parameter structure is created.'];
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'out_path';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Output directory.';
    DESC = 'Full path to output directory.';
    DTYPE = 'A string.';
    DEFAULT = '''SIMTB_INSTALL_PATH\\simulations''';
    EXAMPLE = 'out_path = ''X:\\MyData\\Simulations\\''; %% Path to output';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'prefix';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'File prefix.';
    DESC = 'String used as a prefix for all output files.';
    DTYPE = 'A string.';
    DEFAULT = '''sim''';
    EXAMPLE = 'prefix = ''sim8''; %% All filenames will have ''sim8'' as a prefix.';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end

thisparam = 'pfile';
if strmatch(upper(P), upper(thisparam))
    LABEL = 'Parameter file.';
    DESC = 'File used to created parameter structure (if any).';
    DTYPE = 'A string.';
    DEFAULT = 'Full filename of parameter file (if used).';
    EXAMPLE = '%% NOT a user-specified parameter.  Auto-generated in simtb_create_sP';
    Pdescription = P_found(Pdescription, thisparam, DESC, DTYPE, EXAMPLE, DEFAULT);
end



if isempty(Pdescription)
    Pdescription = P_not_found(P);
    LABEL = [];
    DESC = [];
    DTYPE = [];
    DEFAULT = [];
    EXAMPLE = [];
end

%% Format the output
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargout
    varargout{1} = Pdescription;
    varargout{2} = DESC;
    varargout{3} = DTYPE;
    varargout{4} = EXAMPLE;
    varargout{5} = LABEL;
    varargout{6} = DEFAULT;
else
    fprintf('---------------------------------------------------------------------------------------\n');
    disp(Pdescription);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function message = P_not_found(P)
message1 = sprintf('       NAME: %s\n', P);
message2 = sprintf('    PROBLEM: ''%s'' is not a defined simulation parameter.\n', P);
message3 = sprintf('   SOLUTION: Type simtb_params for full list simulation parameters.\n');
message = [message1, message2, message3];


function NEWdescription = P_found(OLDdescription, P, DESC, DTYPE, EXAMPLE, DEFAULT)

message1 = sprintf('   NAME: %s\n', P);
message2 = sprintf('   DESC: %s\n', format_line_breaks(DESC));
message3 = sprintf('   TYPE: %s\n', format_line_breaks(DTYPE));
message4 = sprintf('DEFAULT: %s\n', format_line_breaks(DEFAULT));
message5 = sprintf('EXAMPLE: %s\n', format_line_breaks(EXAMPLE));
message6 = sprintf('---------------------------------------------------------------------------------------\n');
NEWdescription = [OLDdescription, message1, message2, message3, message4, message5, message6];


function NEW = format_line_breaks(S)
ncol = 80;
wspace = ['         '];
NEW = [];
nline = 0;
while length(S)>ncol 
    br = strfind(S, '\n');
    if ~isempty(br) & br(1) < ncol
        lastIND = br(1);
        newLINE = [S(1:lastIND+1)];
        S = S(lastIND+2:end);
    else
        sp = strfind(S, ' ');
        beforeIND = find(sp-ncol < 0);
        lastIND = sp(beforeIND(end));
        newLINE = [S(1:lastIND) '\n'];
        S = S(lastIND+1:end);
    end
        
    nline = nline+1;
    if nline>1
        newLINE = [wspace newLINE];
    end
    NEW = [NEW newLINE];
end
if nline > 0
    NEW = [NEW wspace S];
else
    NEW = [NEW S];
end
NEW = sprintf(NEW);
