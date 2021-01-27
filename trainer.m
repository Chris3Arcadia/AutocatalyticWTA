%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      Copyright (c) 2021, Christopher E. Arcadia (CC BY-NC 4.0)      %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [w,performance,training,testing] = trainer(x,y,w0,alpha,epoch,fraction,seed,verbose)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Train Winner-Take-All (WTA) Network
%
% Inputs:
%   x - training data (matrix with columns of training vectors) [Nf,Ne]
%   y - class labels (matrix with columns of training vectors) [1,Ne] (use integers 1,2,...)
%   w0 - the initial weight matrix [Nf,Nc]
%   alpha - the learning rate (for gradient descent)
%   epoch - the number of epochs
%   seed - seed used for random shuffling of training data (leave as [] if you do not wish to specify)
%   fraction - fraction of the total number of examples to use for training 
%   verbose - boolean enabling detailed command line messages
%
% Outputs:
%   w - the final weight vector
%   performance - test performance (objective value) after each epoch
%   training - the indices of training data (numbered with respect to the output x and y)
%   testing - the indices of testing data (numbered with respect to the output x and y)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% initialize weights
w = w0;
clear w0

% get shape of inputs
%  * Nf = number of features
%  * Ne = number of examples (for training, test, or validation)
%  * Nc = number of classes
[Nf,Ne] = size(x); % [Nf,Ne]  
[~,Ne2] = size(y); %  [1,Ne]
[Nf2,Nc] = size(w); %  [Nf,Nc] 
yUniq = unique(y);
Nc2 = length(yUniq);
if Ne~=Ne2 || Nf~=Nf2 || Nc~=Nc2
    error('Input data sizes are invalid.')
end
clear Ne2 Nf2 Nc2

% randomize training data    
if isempty(seed)
    shuff.seed = rng;
else
    rng(seed);
    shuff.seed = seed;
end
shuff.perm = randperm(Ne);
x = x(:,shuff.perm);
y = y(shuff.perm);

% normalize the weights and training data
for c = 1:Nc
    w(:,c) = w(:,c)./(norm(w(:,c)));
end
xnorm = ones(size(x(1,:)));
for e = 1:Ne
    xnorm(e) = norm(x(:,e));
    x(:,e) = x(:,e)./xnorm(e);
end

% split data into testing and training sets
all = 1:Ne;
training = randperm(round(Ne*fraction)); 
testing = all;
% if there are examples left for testing
if length(training)~=length(all) 
    testing(training) = []; 
else
    % otherwise reuse training examples for testing (not advised) 
end

% perform optimization of weights
sqrdL2diff = @(x,w) sum((w-x).^2); % squared L-2 norm of the difference
performance = zeros([epoch,length(testing)]); % track over all epochs
perfMeanCurr = 0;
% loop over each epoch
for n = 1:epoch 
        % loop over each train example
        for e = training 
            % find optimal weights for each class
            for c=1:Nc 
                % perform gradient descent
                if yUniq(c)==y(e)
                    gradient = -2*(w(:,c)-x(:,e));  
                else
                    gradient = (2/(Nc-1))*(w(:,c)-x(:,e));
                end
                w(:,c) = w(:,c) + alpha*gradient;

                % normalize weights to max                                 
                w(:,c) = w(:,c)./(max(abs(w(:,c)))); 

                % clip off negative weights
                w(w(:,c)<0,c) = 0;
            end
        end
        counter = 1;
        % loop over each test example 
        for e = testing
            % loop over each class 
            xTest = xnorm(e)*x(:,e);
            for c=1:Nc 
                % evaluate the portion of the objective function related to the current class 
                if yUniq(c)==y(e)
                    factor = +1;
                else % yUniq(cc)==y(e)
                    factor = -1/(Nc-1);
                end
                performance(n,counter) = performance(n,counter) + factor*sqrdL2diff(xTest,w(:,c));                 
            end
            counter = counter + 1;
        end          
        perfMeanLast = perfMeanCurr;
        perfMeanCurr = mean(performance(n,:));
    if verbose
        disp(['iteration: ' num2str(n) ', mean performance: ' sprintf('%0.4e',perfMeanCurr) ', change: ' sprintf('%0.4e',perfMeanCurr-perfMeanLast)]);
    end
end

% reference indices to the original data
training = shuff.perm(training);
testing = shuff.perm(testing);

end