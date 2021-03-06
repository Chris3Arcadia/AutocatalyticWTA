%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Copyright (c) 2021, Christopher E. Arcadia (CC BY-NC 4.0)      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Select Database Subset

% set classes to use for demonstration
demo = struct();
demo.name = option.classes;
demo.num = length(demo.name);
demo.id = 1:demo.num;
demo.index = zeros(size(demo.name));
demo.count = zeros(size(demo.name));
demo.positions = cell(size(demo.name)); 
for n = 1:demo.num
     loc = find(contains(database.classnames,demo.name{n}));
     if isempty(loc)
         error(['Could not find "' demo.name{n} '"'])
     else
         demo.index(n) = loc(1);
         demo.positions{n} = find(database.Y==demo.index(n));
         demo.count(n) = length(demo.positions{n} );         
     end
end
if option.verbose
    disp(['Selected the following classes to use: ' strjoin(demo.name,', ') '.'])
end
clear n loc

% show an example picture from each class
figure('color','w','name','Classes')
nsq = ceil(sqrt(demo.num)); 
instances = ones(length(demo.name)); % select first instances
for n = 1:demo.num
    subplot(nsq,nsq,n)
    imshow(func.reshaper(database.X(demo.positions{n}(instances(n)),:)))
    set(gca,'visible','on','linewidth',option.image_border_width,'xtick',[],'ytick',[],'box','on','xcolor','k','ycolor','k')    
    title(demo.name{n},'fontweight','normal')
end
clear nsq instances n

% show all pictures from each class
if option.show_all_images
    for n = 1:demo.num
    figure('color','w','name',['Class - ' demo.name{n}],'units','normalized','position',[0,0,1,1])
    nsq = ceil(sqrt(max(demo.count)));
        for o = 1:demo.count(n)
            subplot(nsq,nsq,o)
            imshow(func.reshaper(database.X(demo.positions{n}(o),:)))  
            set(gca,'visible','on','linewidth',option.image_border_width,'xtick',[],'ytick',[],'box','on','xcolor','k','ycolor','k')    
            title(num2str(o),'fontweight','normal')
        end
    end
    clear nsq n o
end
