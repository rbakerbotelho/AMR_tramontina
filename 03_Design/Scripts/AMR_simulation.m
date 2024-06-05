clear('variables');
close('all');
clc;

% Add os paths dos modelos
model='simulAMR_stateflow';
addpath(genpath(fileparts( which(model) )));

% rotas EXTERNAS pré-cadastradas
T_out0 = readtable(which('route6.csv')); % 'T' atrás tintas
T_out1 = readtable(which('route7.csv')); % Linha Reta 239

% rotas INTERNAS pré-cadastradas
T_ind0 = readtable(which('mapa_aplicacao_fundos_20240514_result.csv'));

T=T_ind0;

%% Define os parâmetros de SIMULAÇÃO
num_of_wps = size(T, 1);
tstep = 500e-3;
tfinal = 1;
L = 1.5;
vehicle_wheelbase = 2.367; %[m]
yaw_diff_threshold = 20; %[deg]
search_radius = 2*L; 


%% SIMUL param
% Abre o modelo
% open_system(model);


%% Server
%Inicia o servidor web para receber dados do AGV
% Executar uma unica vez o comando abaixo para abrir a interface web
%system("start cmd /k python web_interface.py");


%% Simul
% Simula
S = sim(model);


%% Plot
% Separa as variáveis observadas
AMR_t = S.logsout{1}.Values.Time;
AMR_x = S.logsout{3}.Values.Data(:);
AMR_y = S.logsout{4}.Values .Data(:);
route_x = S.logsout{39}.Values.Data(:);
route_y = S.logsout{40}.Values.Data(:);

% fh = figure();
% fh.WindowState = 'maximized';
% p=plot(route_x, route_y,'-o');
% p.MarkerSize = 5;
% hold on
% plot(AMR_x, AMR_y, 'LineWidth',2);
% legend('target','executed')
% grid minor 


% Your existing code
fh = figure();
fh.Position = [100, 100, 800, 800]; % [left, bottom, width, height]
p = plot(route_x, route_y, '-o');
p.MarkerSize = 5;
hold on;
plot(AMR_x, AMR_y, 'LineWidth', 2);
legend('target', 'executed');
grid minor;

% Center coordinates
centerX = 15;
centerY = -11;

% Radius of the circle


% Plot the circle
rectangle('Position', [centerX-search_radius, centerY-search_radius, 2*search_radius, 2*search_radius],...
    'Curvature', [1, 1], 'EdgeColor', 'b', 'LineStyle', '--', 'LineWidth', 2);

% Plot the center point
plot(centerX, centerY, 'ro', 'MarkerSize', 10); % Red dot
legend('target', 'executed','vehicle');


% % Geoplot Figura total
% figure('color','w');
% geoplot(T1.Latitude,T1.Longitude,'b-*','LineWidth',2);
% hold('on');
% geoplot(AGV_lat,AGV_lng,'r-','LineWidth',2)
% geobasemap satellite;

% Faz um video
% run('scripts\create_video.m');






% Coeficientes da linha reta
a = -0.92;
b = 3.55;

% Gerar vetor x de 0 a 20
x = linspace(0, 20, 100); % 100 pontos entre 0 e 20

% Calcular os valores de y para a linha reta
y = a*x + b;

% Plotar a linha reta
figure;
plot(x, y, 'b', 'LineWidth', 2);
hold on;

% Plotar o círculo
theta = linspace(0, 2*pi, 100); % ângulos para desenhar o círculo
circle_x = 15 + 3*cos(theta); % coordenadas x do círculo
circle_y = -11 + 3*sin(theta); % coordenadas y do círculo
plot(circle_x, circle_y, 'r', 'LineWidth', 2);

% Adicionar legendas e rótulos
legend('Linha Reta', 'Círculo');
xlabel('x');
ylabel('y');
title('Linha Reta e Círculo');
axis equal;
grid on;







% 
% 
% 
% 
% clear variables;
% close all;
% clc;
% 
% % Add os paths dos modelos
% model = 'simulAMR_stateflow';
% addpath(genpath(fileparts(which(model))));
% 
% % rotas EXTERNAS pré-cadastradas
% T_ext0 = readtable(which('route6.csv')); % 'T' atrás tintas
% T_ext1 = readtable(which('route7.csv')); % Linha Reta 239
% 
% % rotas INTERNAS pré-cadastradas
% T_ind0 = readtable(which('mapa_aplicacao_fundos_20240514_result.csv'));
% 
% T = T_ind0;
% 
% 
% %% SIMUL param
% % Abre o modelo
% %open_system(model);
% 
% % Define os parâmetros de SIMULAÇÃO
% num_of_wps = size(T, 1);
% tstep = 50e-3;
% tfinal = 500;
% vehicle_wheelbase = 2.367; %[m]
% 
% 
% % Define the range of L values
% L_values = 0.5:0.5:2;
% 
% % Initialize variables to store results
% errors = zeros(size(L_values));
% 
% % Loop through each value of L
% for idx = 1:numel(L_values)
%     L = L_values(idx);
% 
%     % SIMUL param
%     % Simula
%     S = sim(model);
% 
%     % Separa as variáveis observadas
%     AMR_t = S.logsout{1}.Values.Time;
%     AMR_x = S.logsout{3}.Values.Data(:);
%     AMR_y = S.logsout{4}.Values.Data(:);
%     route_x = S.logsout{29}.Values.Data(:);
%     route_y = S.logsout{30}.Values.Data(:);
% 
%     x_simulated = AMR_x;
%     y_simulated = AMR_y;
%     x_original = route_x;
%     y_original = route_y;
% 
%     % Initialize a figure
%     figure;
% 
%     % Plot the original curve
%     plot(x_original, y_original, '-o', 'LineWidth', 2);
%     hold on;
%     % Plot the simulated curve
%     plot(x_simulated, y_simulated, 'r-', 'LineWidth', 1);
% 
%     % Calculate the number of points in each path
%     num_points_original = size(x_original, 1);
%     num_points_simulated = size(x_simulated, 1);
% 
%     % Initialize variable to store the total error
%     total_error = 0;
% 
%     % Loop through each point in the original curve
%     for i = 1:num_points_original
%         % Calculate the Euclidean distance between the current point in the original curve and all points in the simulated curve
%         distances = sqrt((x_simulated - x_original(i)).^2 + (y_simulated - y_original(i)).^2);
% 
%         % Find the index of the simulated point that is closest to the current point in the original curve
%         [~, closest_index] = min(distances);
% 
%         % Calculate the distance between the closest simulated point and the current point in the original curve
%         distance = sqrt((x_simulated(closest_index) - x_original(i))^2 + (y_simulated(closest_index) - y_original(i))^2);
% 
%         % Add the distance to the total error
%         total_error = total_error + distance;
% 
%         % Plot the corresponding points
%         plot([x_original(i), x_simulated(closest_index)], [y_original(i), y_simulated(closest_index)], 'k-o');
%     end
% 
%     % Set axis labels
%     xlabel('X');
%     ylabel('Y');
% 
%     % Add legend
%     legend('Original Curve', 'Simulated Curve', 'Corresponding Points');
% 
%     % Calculate the average error
%     average_error = total_error / num_points_original;
% 
%     % Store the error for this value of L
%     errors(idx) = average_error;
% 
%     % Display the average error
%     disp(['Average error between original and simulated paths for L = ', num2str(L), ': ', num2str(average_error)]);
% 
%     % Add annotation with the value of L and error
%     annotation('textbox', [0.2, 0.2, 0.3, 0.1], 'String', {['L = ', num2str(L)], ['Error = ', num2str(average_error)]}, 'FitBoxToText', 'on');
% 
%     grid minor  
% end
% 
% % Display the list of calculated values for each L
% disp('List of calculated values for each L:');
% disp(['L_values: ', num2str(L_values)]);
% disp(['Errors: ', num2str(errors)]);
% 
% % Find the value of L that minimizes the total_error
% [min_error, min_idx] = min(errors);
% optimal_L = L_values(min_idx);
% 
% % Display the optimal value of L
% disp(['Optimal value of L: ', num2str(optimal_L)]);
