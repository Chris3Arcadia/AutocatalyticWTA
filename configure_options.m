%% Configure Program Options

% initialize options structure
option = struct();

% set database path
option.database_path = '__develop__/caltech101_silhouettes_16.mat';

% select classes to use
option.classes = {'starfish','kangaroo','llama','dragonfly','ibis'};

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
