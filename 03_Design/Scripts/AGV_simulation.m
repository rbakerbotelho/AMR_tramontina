clear('variables');
close('all');
clc;

% Add os paths dos modelos
addpath('.\models\');

% Lê as rotas pré-cadastradas
% T1 = readtable('.\stateFlow\current\routes\route1.csv');
% T2 = readtable('.\stateFlow\current\routes\route2.csv');
% T3 = readtable('.\stateFlow\current\routes\route3.csv');
% T4 = readtable('.\stateFlow\current\routes\route4.csv');
% T5 = readtable('.\stateFlow\current\routes\route5.csv');
T6 = readtable(which('route7.csv')); % 'T' atrás tintas
T7 = readtable(which('route7.csv')); % Linha Reta 239

%% Define os parâmetros de simulação
num_of_wps = size(T6, 1);
tstep = .01;
tfinal = inf;
L = 2;

% % Abre o modelo
% % open_system('.\models\AGV_stateFlow.slx');
% 
% % Inicia o servidor web para receber dados do AGV
% % Executar uma unica vez o comando abaixo para abrir a interface web
% % system("start cmd /k python web_interface.py");
% 
% % Simula
% S = sim('.\models\AGV_stateFlow.slx');
% 
% %% Separa as variáveis observadas
% AGV_t = S.logsout{1}.Values.Time;
% AGV_lat = S.logsout{1}.Values.Data(:);
% AGV_lng = S.logsout{2}.Values .Data(:);
% AGV_heading = S.logsout{3}.Values.Data(:);
% AGV_speed = S.logsout{4}.Values.Data(:);
% AGV_moving = S.logsout{5}.Values.Data(:);
% AGV_state = S.logsout{6}.Values.Data(:);
% 
% % Geoplot Figura total
% figure('color','w');
% geoplot(T1.Latitude,T1.Longitude,'b-*','LineWidth',2);
% hold('on');
% geoplot(AGV_lat,AGV_lng,'r-','LineWidth',2)
% geobasemap satellite;
% 
% % Faz um video
% % run('scripts\create_video.m');