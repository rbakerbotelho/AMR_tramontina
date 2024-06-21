clear('variables');
close('all');
clc;

% Add os paths dos modelos
model='ComissionamentoMesa';
addpath(genpath(fileparts( which(model) )));

%% DEPLOY param
% Abre o modelo
%open_system(model);


%% DEPLOY
% slrtExplorer
tg = slrealtime('10.200.38.50');
tg.connect
speedgoat.setTargetTime(datenum(datetime('now', TimeZone='America/Sao_Paulo')))
tg.status
tg.stop
tg.status
model='ComissionamentoMesa';
slbuild(model)
tg.load(model)
tg.start
tg.status