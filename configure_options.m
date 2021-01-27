%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Copyright (c) 2021, Christopher E. Arcadia (CC BY-NC 4.0)      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Configure Program Options

% initialize options structure
option = struct();

% set database path
option.database_path = '__develop__/caltech101_silhouettes_16.mat';

% select classes to use
option.classes = {'starfish','kangaroo','llama','dragonfly','ibis'}; 

% select number of training epochs
option.epochs = 700;

% select the fraction of data used for training
option.train_fraction = 70/100;

% select gradient descent step size
option.descent_step = 0.0005;

% print detailed command line messages
option.verbose = true; 

% print detailed training updates
option.verbose_training = false; 

% print detailed simulation updates
option.verbose_simulation = true; 

% show all the images of each class
option.show_all_images = false;

% image axis border thickness
option.image_border_width = 0.75; 

% seed random number generator
option.random_seed = 0;
rng(option.random_seed);

