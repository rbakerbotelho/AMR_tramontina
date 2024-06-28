clear('variables');
close('all');
clc;

% Add os paths dos modelos
model='AMR_main_24a';
addpath(genpath(fileparts( which(model) )));

% rotas EXTERNAS pré-cadastradas
T_out0 = readtable(which('routeT.csv')); % 'T' atrás tintas
T_out1 = readtable(which('route7.csv')); % Linha Reta 239

% rotas INTERNAS pré-cadastradas
% T_ind0 = readtable(which('route_teste_aplicacao_fundo.csv'));
% T_ind0 = readtable(which('MapaTintasInternoTraj_20240626_result.csv'));
T_ind0 = readtable(which('TrajetoriaTintasInterno_20240626_result.csv'));

T=T_out0;

%% DEPLOY param
% Abre o modelo
%open_system(model);

%% Define os parâmetros de DEPLOY
num_of_wps = size(T, 1);
tfinal = inf;
L = 1.5; % look-ahead distance [m]


%% DEPLOY
% slrtExplorer
tg = slrealtime('10.200.38.50');
tg.connect
speedgoat.setTargetTime(datenum(datetime('now', TimeZone='America/Sao_Paulo')))
tg.status
tg.stop
tg.status
model = 'AMR_main_24a';
slbuild(model)
tg.load(model)
tg.start
tg.status