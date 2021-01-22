%% Train Winner-Take-All Network

% set training parameters
training = struct();
training.alpha = 0.0005; % descent step size 
training.epoch = 700; % number of training epochs
training.fraction = 70/100; % train to total data split
training.seed = 10; % random number generator seed
if option.verbose
    disp(['Training network over ' num2str(training.epoch) ' epochs with ' num2str(training.fraction*100) '% of the available data using a step size of ' num2str(training.alpha) '.'])
end

% train the model
training.w0 = rand([prod(database.dimensions),demo.num]); 
training.x = double(database.X(cell2mat(demo.positions),:))';        
training.y = double(database.Y(cell2mat(demo.positions)));   
for n=1:demo.num
   training.y(training.y==demo.index(n)) = demo.index(n);
end
[training.w, training.performance, training.indices_train, training.indices_test] = trainer(training.x,training.y,training.w0,training.alpha,training.epoch,training.fraction,training.seed,option.verbose_training);    
training.count_train = length(training.indices_train);
training.count_test = length(training.indices_test);

% associate weights with their classes
training.class_index = demo.index;
training.class_name = demo.name;
[~,indsort] = sort(demo.index);
[~,indunsort] = sort(indsort);
training.w = training.w(:,indunsort);
clear sorted indsort indunsort

if option.verbose
    disp(['Trained network using ' num2str(training.count_train) ' images and evaluated performance on ' num2str(training.count_test) ' images.'])
end

% review trained weights
figure('color','w','name','Weights');
nsq = ceil(sqrt(demo.num));
for n = 1:demo.num
    subplot(nsq,nsq,n)
    imshow(func.reshaper(training.w(:,n)))   
    title(training.class_name{n},'fontweight','normal')
    imborder(gca,option.image_border_width,'k')
end 
clear nsq n

% review objective value change over training
figure('color','w','name','Objective during Training')
subplot(2,1,1)
    plot(1:training.epoch,mean(training.performance,2),'-','linewidth',3)
    title(['Evaluated On ' num2str(training.count_test) ' Test Images (' sprintf('%0.1f',(training.count_test)/(training.count_train+training.count_test)*100) '% of the available data)'],'fontweight','normal')
    grid on; box on;
    axis tight
    xlim(xlim+diff(xlim)*[-1,1]*1/60)
    ylim(ylim+diff(ylim)*[-1,1]*1/20)
    xlabel('Training Epoch')
    ylabel('Mean Objective Value')
subplot(2,1,2)
    plot(2:training.epoch,diff(mean(training.performance,2)),'-','linewidth',3)
    grid on; box on;
    axis tight
    xlim(xlim+diff(xlim)*[-1,1]*1/60)
    %ylim(ylim+diff(ylim)*[-1,1]*1/20)
    set(gca,'yscale','log')
    xlabel('Training Epoch')
    ylabel('Mean Objective Change')