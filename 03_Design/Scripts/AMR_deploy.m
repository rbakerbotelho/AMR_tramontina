clear('variables');
close('all');
clc;

% Add os paths dos modelos
model='AMR_main_24a';
addpath(genpath(fileparts( which(model) )));

% rotas EXTERNAS pré-cadastradas
T_ext0 = readtable(which('route6.csv')); % 'T' atrás tintas
T_ext1 = readtable(which('route7.csv')); % Linha Reta 239

% rotas INTERNAS pré-cadastradas
T_ind0 = readtable(which('route_teste_aplicacao_fundo.csv'));

T=T_ind0;

%% Define os parâmetros de DEPLOY
num_of_wps = size(T, 1);
tfinal = inf;
L = 0.25;