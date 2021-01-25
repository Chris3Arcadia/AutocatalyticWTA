%% Set Experiment Parameters

% initialize structure of parameters
param = struct();

% fluid handling limits
param.Vdelta = 2.5e-9; % minimum non-zero transfer volume [L]
param.Vu = 200e-9; % chosen upper limit for transfer volume [L]

% data plate
param.Vs = 9.5e-6; % volume of solvent to add to make data wells [L]
param.Vd = 0.2e-6; % volume of stock catalyst to add to high-valued data wells [L]
param.Do = 618e-3; % concentration of stock catalyst [M]
param.c = param.Do*param.Vd/(param.Vd+param.Vs); % concentration of catalyst in high-valued data wells [M]

% reaction plate
param.Vp = 1e-6; % volume of pooled solution to add to reaction well [L]
param.Vr = 50e-6; % volume of starting reagent solution to add to reaction well [L]

% time to transition 
param.alpha = 2.81e-3; % alpha [M]
param.beta = 14.2e-6; % beta [M]
param.k = 970; % k [1/M * 1/hr]

%% Specify Experiment Functions (Based on the given parameters.)

% initialize structure of functions
func = struct();

% pool plate
%  * must provide data well concentrations (d) [M] and/or the class weight (w)
func.Vpool = @(w) param.Vu*sum(w); % total pool volume [L]
func.Cpool = @(d,w) (dot(d,w)*param.Vu)/func.Vpool(w); % catalyst concentration in pool well [M]

% reaction plate
func.Creact = @(p) p*param.Vp/(param.Vp+param.Vr); % initial catalyst concentration in reaction well [M]

% time to transition
%  * must provide the seed catalyst concentration (r) [M] 
func.time2trans = @(r) 60^2 * log(2+param.alpha/(r+param.beta)) / ( (param.alpha+r+param.beta) * param.k); % transition time [s] 

