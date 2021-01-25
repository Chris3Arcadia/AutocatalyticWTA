%% Main Script 
%   for training and testing the network described in "Leveraging autocatalytic reactions for chemical-domain image classification"
%   by Chris Arcadia (Chris3Arcadia, christopher_arcadia@brown.edu, Brown University, c 2021)

% load settings
configure_options
set_parameters

% prepare data
load_data
select_data

% train and test the network
train_network
simulate_experiment