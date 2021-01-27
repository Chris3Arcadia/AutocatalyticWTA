%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Copyright (c) 2021, Christopher E. Arcadia (CC BY-NC 4.0)      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Train Winner-Take-All Network

% set training parameters
training = struct();
training.alpha = option.descent_step; % descent step size 
training.epoch = option.epochs; % number of training epochs
training.fraction = option.train_fraction; % train to total data split
if option.verbose
    disp(['Training network over ' num2str(training.epoch) ' epochs with ' num2str(training.fraction*100) '% of the available data using a step size of ' num2str(training.alpha) '.'])
end

% train the model
training.guess_seed = 0; % random number generator seed for initial guess   
rng(training.guess_seed);
training.w0 = rand([prod(database.dimensions),demo.num]); 
training.x = double(database.X(cell2mat(demo.positions),:))';        
training.y = double(database.Y(cell2mat(demo.positions)));   
for n=1:demo.num
   training.y(training.y==demo.index(n)) = demo.index(n);
end
training.train_seed = 10; % random number generator seed for initial guess    
[training.w, training.performance, training.indices_train, training.indices_test] = trainer(training.x,training.y,training.w0,training.alpha,training.epoch,training.fraction,training.train_seed,option.verbose_training);    
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
    set(gca,'visible','on','linewidth',option.image_border_width,'xtick',[],'ytick',[],'box','on','xcolor','k','ycolor','k')    
end 
clear nsq n

% review objective value change over training
figure('color','w','name','Objective during Training')
subplot(2,1,1)
    plot(1:training.epoch,mean(training.performance,2),'.','markersize',10)
    title(['Evaluated On ' num2str(training.count_test) ' Test Images (' sprintf('%0.1f',(training.count_test)/(training.count_train+training.count_test)*100) '% of the available data)'],'fontweight','normal')
    grid on; box on;
    axis tight
    xlim(xlim+diff(xlim)*[-1,1]*1/60)
    ylim(ylim+diff(ylim)*[-1,1]*1/20)
    xlabel('Training Epoch')
    ylabel('Mean Objective Value')
subplot(2,1,2)
    ind = 2:training.epoch;
    delta = diff(mean(training.performance,2));
    neg = delta<0;
    pos = delta>0;
    hold on
    legstr = '';
    if any(neg)
        legstr = [legstr,{'-'}];
        plot(ind(neg),-delta(neg),'.','markersize',10)
    end
    if any(pos)
        legstr = [legstr,{'+'}];       
        plot(ind(pos),delta(pos),'.','markersize',10)
    end
    hold off
    grid on; box on;
    legend(legstr)
    axis tight
    xlim(xlim+diff(xlim)*[-1,1]*1/60)
    ylim(ylim.*[2/3,3/2])
    set(gca,'yscale','log')
    xlabel('Training Epoch')
    ylabel('Mean Objective Change')
    clear ind delta neg pos
   
