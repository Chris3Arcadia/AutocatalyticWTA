%% Analyze Dataset 

% load settings and data
configure_options
set_parameters
load_data

% get class-averaged images 
avg = struct();
x = database.X;
y = database.Y;
avg.y = unique(y)';
avg.count = length(avg.y);
avg.x = zeros(avg.count,size(database.X,2));
avg.name = database.classnames';
for n=1:avg.count
    Y = avg.y(n);
    indices = find(y==Y);
    X = x(indices,:);
    avg.x(n,:) = mean(X,1);
end
clear x y X Y n indices

% show all class-averaged images
figure('color','w','name','Class Averaged Images')
nsq = ceil(sqrt(avg.count));
for n=1:avg.count
    subplot(nsq,nsq,n)
        imagesc(func.reshaper(avg.x(n,:)))
        colormap(gca,'gray')    
        title(['(' num2str(avg.y(n)) ')' newline avg.name{n}],'fontweight','normal','fontsize',6)
        axis off
        axis equal
        box on
end
clear n nsq

% measure the similarity between class-averaged images
func.euclidean = @(a,b) sqrt(sum((a-b).^2)); % Euclidean distance
avg.distance = zeros(avg.count,avg.count);
for i=1:avg.count
    for j=1:avg.count
        avg.distance(i,j) = func.euclidean(avg.x(i,:),avg.x(j,:));
    end
end
clear i j

%% visual image distances
figure('color','w','name','Comparing Class Averaged Image')
imagesc(avg.distance); 
colormap(gca,'gray')
xlabel('Class Index')
ylabel('Class Index')
axis equal
axis tight
colorbar
title('Euclidean Distance between Class-Averaged Images','fontweight','normal')

