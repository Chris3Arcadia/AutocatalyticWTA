%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Copyright (c) 2021, Christopher E. Arcadia (CC BY-NC 4.0)      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Simulate  Experiment  

% set training parameters
simulation = struct();

% get the expected time to transition for each image and weight vector
num_images = size(training.x,2);
num_classes = demo.num;
simulation.time = zeros(num_images,num_classes);
for i = 1:num_images
    for j = 1:num_classes
         % get current image
        im = training.x(:,i);
        
        % get current weight
        w = training.w(:,j); 
        
        % compute data plate catalyst concentration
        d = im*param.c; 
        
        % compute pool plate catalyst concentration
        p = func.Cpool(d,w); 
        
        % compute reaction plate initial catalyst concentration
        r = func.Creact(p); 
        
        % compute expected time to transition
        t = func.time2trans(r); 
        
        % store time to transition
        simulation.time(i,j) = t;
    end
end
clear i j im w d p r t 

% determine class labels based on time to transitions
[~,simulation.winner] = min(simulation.time,[],2);
simulation.y = training.class_index(simulation.winner)';
simulation.match = training.y' == simulation.y;

% assess overall classification results 
simulation.accuracy = struct();
simulation.accuracy.all = sum(simulation.match)/length(simulation.match);
simulation.accuracy.train = sum(simulation.match(training.indices_train))/length(simulation.match(training.indices_train));
simulation.accuracy.test = sum(simulation.match(training.indices_test))/length(simulation.match(training.indices_test));
if option.verbose
    disp(['Classification Accuracy: ' sprintf('%0.2f',100*simulation.accuracy.all) '% overall, ' ...
          '' sprintf('%0.2f',100*simulation.accuracy.train) '% on training data, ' ...
          '' sprintf('%0.2f',100*simulation.accuracy.test) '% on test data.' ...
    ])
end

% assess class confusion
simulation.confusion = confusionmat(training.y,simulation.y);
figure('color','w','name','Overall Confusion Matrix')
confusionchart(simulation.confusion,demo.name,'fontsize',13);

% clean up 
clear num_images num_classes 
