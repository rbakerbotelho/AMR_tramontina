clear('variables');
close('all');
clc;

% Add os paths dos modelos
model='simulAMR_stateflow';
addpath(genpath(fileparts( which(model) )));

% rotas EXTERNAS pré-cadastradas
T_ext0 = readtable(which('route6.csv')); % 'T' atrás tintas
T_ext1 = readtable(which('route7.csv')); % Linha Reta 239

% rotas INTERNAS pré-cadastradas
T_ind0 = readtable(which('mapa_aplicacao_fundos_20240514_result.csv'));

T=T_ind0;

%% Define os parâmetros de SIMULAÇÃO
num_of_wps = size(T, 1);
tstep = 50e-3;
tfinal = 500;
L = 0.5;

%% SIMUL param
% Abre o modelo
open_system(model);

%Inicia o servidor web para receber dados do AGV
% Executar uma unica vez o comando abaixo para abrir a interface web
%system("start cmd /k python web_interface.py");

% Simula
S = sim(model);

% Separa as variáveis observadas
AMR_t = S.logsout{1}.Values.Time;
AMR_x = S.logsout{3}.Values.Data(:);
AMR_y = S.logsout{4}.Values .Data(:);
AMR_heading = S.logsout{8}.Values.Data(:);
AMR_speed = S.logsout{7}.Values.Data(:);
AMR_moving = S.logsout{15}.Values.Data(:);
AMR_state = S.logsout{2}.Values.Data(:);
route_x = S.logsout{24}.Values.Data(:);
route_y = S.logsout{25}.Values.Data(:);



p=plot(route_x, route_y,'-o');
p.MarkerSize = 5;
hold on
plot(AMR_x, AMR_y);
legend('target','executed')
grid minor 





model='C:\Users\ander\Desktop\AGV_stateFlow22a.slx';
S = sim(model);

% %% Separa as variáveis observadas
AGV_t = S.logsout{1}.Values.Time;
AGV_lat = S.logsout{1}.Values.Data(:);
AGV_lng = S.logsout{2}.Values .Data(:);
AGV_speed = S.logsout{3}.Values.Data(:);
AGV_heading = S.logsout{4}.Values.Data(:);
AGV_moving = S.logsout{11}.Values.Data(:);
AGV_state = S.logsout{12}.Values.Data(:);
AGV_X = S.logsout{14}.Values.Data(:);
AGV_Y = S.logsout{15}.Values.Data(:);


p=plot(AGV_X, AGV_Y,'-o');
p.MarkerSize = 5;
hold on
plot(AGV_lat, AGV_lng)
legend('target','executed')
grid minor 


% % Geoplot Figura total
% figure('color','w');
% geoplot(T1.Latitude,T1.Longitude,'b-*','LineWidth',2);
% hold('on');
% geoplot(AGV_lat,AGV_lng,'r-','LineWidth',2)
% geobasemap satellite;

% Faz um video
% run('scripts\create_video.m');