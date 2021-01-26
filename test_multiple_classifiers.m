%% Script to Test Multiple Classifiers 

% configure script options
multitest = struct();
multitest.option.iterations = 100;
multitest.option.train_epochs = 700;
multitest.option.class_count = 5;
multitest.option.random_seed = 0;

% load settings and data
configure_options
set_parameters
load_data

% override some defaults
option.epochs = multitest.option.train_epochs;
option.verbose = false;
option.verbose_simulation = false;
option.verbose_training = false;
option.show_all_images = false;

% initialize output fields
num_class = length(database.classnames);
num_iter = multitest.option.iterations;
multitest.training = cell(num_iter,1);
multitest.simulation = cell(num_iter,1);
multitest.class.indices = 1:num_class;
multitest.class.names = database.classnames;
multitest.class.mask = zeros(num_iter,num_class);
multitest.summary = table();
multitest.summary.iteration = zeros(num_iter,1);
multitest.summary.accuracy = zeros(num_iter,1);
multitest.summary.accuracyTrain = zeros(num_iter,1);
multitest.summary.accuracyTest = zeros(num_iter,1);
multitest.summary.classes = cell(num_iter,1);

% test multiple classifiers
rng(multitest.option.random_seed) % seed the random number generator for repeatability 
for iter = 1:num_iter 
    disp(['Starting test iteration ' num2str(iter) ' of ' num2str(num_iter) '.'])        
    rng(multitest.option.random_seed + iter) % reseed the random number generator  
    
    % randomly select classes for this iteration
    class_indices = randperm(num_class);    
    class_indices = class_indices(1:multitest.option.class_count);
    class_mask = false(1,num_class);
    class_mask(class_indices) = true;
    option.classes = database.classnames(class_indices);
    class_names = strjoin(option.classes,', ');
    disp(['    - classes selected: ' class_names])   
    
    % run test using the selected classes
    select_data
    train_network
    simulate_experiment
    disp(['    - classification accuracy: ' num2str(simulation.accuracy.all*100) '%'])   
    
    % store output test results
    multitest.training{iter} = training;
    multitest.simulation{iter} = simulation;
    multitest.class.mask(iter,:) = class_mask;    
    multitest.summary.iteration(iter) = iter;
    multitest.summary.accuracy(iter) = simulation.accuracy.all;
    multitest.summary.accuracyTrain(iter) = simulation.accuracy.train;
    multitest.summary.accuracyTest(iter) = simulation.accuracy.test;    
    multitest.summary.classes{iter} = class_names;
    
    % close all autogenerated figures
    close all
end
clear iter num_iter num_class class_indices class_names class_mask simulation training
disp('Completed all test iterations.')

% check uniqueness of class selections
[~,ind_unique] = unique(multitest.class.mask,'rows');
num_unique = length(ind_unique);
if num_unique ~= multitest.option.iterations
    disp(['Note that some iterations are redundant (' num2str(multitest.option.iterations-num_unique) ' out of ' num2str(multitest.option.iterations) ').'])
end
multitest.class.uniques = false(multitest.option.iterations,1);
multitest.class.uniques(ind_unique) = true;
multitest.summary.unique = multitest.class.uniques;
clear ind_unique num_unique 

% review classification results
disp(multitest.summary)
disp(['Mean Classification Accuracy: ' sprintf('%0.2f',100*mean(multitest.summary.accuracy(multitest.class.uniques))) '% overall, ' ...
      '' sprintf('%0.2f',100*mean(multitest.summary.accuracyTrain(multitest.class.uniques))) '% on training data, ' ...
      '' sprintf('%0.2f',100*mean(multitest.summary.accuracyTest(multitest.class.uniques))) '% on test data.' ...
])

% visualize classification results
figure('color','w','name','Multiple Main Test Results'); 
subplot(2,1,1)
    histogram(multitest.summary.accuracy(multitest.class.uniques)*100)
    xlabel('Accuracy [%]')
    ylabel('Count')
    hold on
    plot([1,1]*(1/multitest.option.class_count)*100,ylim,'--','linewidth',2)
    hold off
subplot(2,1,2)
    plot(multitest.summary.iteration(multitest.class.uniques),multitest.summary.accuracy(multitest.class.uniques)*100,'.','markersize',15)
    xlabel('Iteration')
    ylabel('Accuracy [%]')
    axis tight
    xlim(xlim+[-1,1]*diff(xlim)*1/50)
    ylim(ylim+[-1,1]*diff(ylim)*1/10)




    