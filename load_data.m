%% Load Image Database

% load all images and labels
database = load(option.database_path);
database.path = option.database_path;
database.num.pixels = size(database.X,2);
database.num.images = size(database.X,1);
database.num.classes = length(database.classnames);
database.dimensions = [16,16];
database.name = 'Caltech 101 Silhouettes';
if option.verbose
    disp(['Loaded all ' 'images from the ' database.name ' database.'])
    disp(['The following classes are available: ' strjoin(database.classnames,', ')])
end
clear path

% function to convert 1-D data to a 2-D image
func.reshaper = @(image_vector) reshape(image_vector,database.dimensions);

% randomize data to make cross validation simple later
database.shuffle.seed = 5;
rng(database.shuffle.seed);
database.shuffle.perm = randperm(database.num.images);
database.Y = database.Y(database.shuffle.perm);
database.X = database.X(database.shuffle.perm,:);

