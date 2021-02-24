%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Copyright (c) 2021, Christopher E. Arcadia (CC BY-NC 4.0)      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Main Script 
%  for training and testing the network described in 
%  "Leveraging autocatalytic reactions for chemical-domain image classification"
%  by Christopher E. Arcadia (christopher_arcadia@brown.edu) 

% load settings
configure_options
set_parameters

% prepare data
load_data
select_data

% train and test the network
train_network
simulate_experiment