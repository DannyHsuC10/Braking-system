clc; clear; close all;
addpath('data');
load_data('data.csv');

% 取得目前檔案資料夾
base_dir = fileparts(mfilename('fullpath'));

%% Basic geometry parameters
% ==================================================

pedal_axis = [0.0, 0.0];
sensor_axis = [px, py];

pedal_push_theta_deg = 11.89;
pedal_push_theta = deg2rad(pedal_push_theta_deg);

%% Initial points
% ==================================================
pedal_force_point = [
    r_pedal * sin(deg2rad(pedal_i_angle_deg)), ...
    r_pedal * cos(deg2rad(pedal_i_angle_deg))
];

pedal_sensor_point = [
    r_sensor * sin(deg2rad(sensor_i_angle_deg)), ...
    r_sensor * cos(deg2rad(sensor_i_angle_deg))
];

%% Simulation setup
% ==================================================
n_step = 101;
theta = linspace(0.0, pedal_push_theta, n_step);
theta_deg = rad2deg(theta);

pedal_x = zeros(1, n_step);
pedal_y = zeros(1, n_step);
sensor_x = zeros(1, n_step);
sensor_y = zeros(1, n_step);
sensor_length = zeros(1, n_step);

%% Main kinematic loop
% ==================================================
for i = 1:n_step
    t = theta(i);

    p_force = rotate_z(pedal_force_point, t);
    p_sensor = rotate_z(pedal_sensor_point, t);

    pedal_x(i) = p_force(1);
    pedal_y(i) = p_force(2);

    sensor_x(i) = p_sensor(1);
    sensor_y(i) = p_sensor(2);

    sensor_length(i) = hypot( ...
        sensor_axis(1) - p_sensor(1), ...
        sensor_axis(2) - p_sensor(2));
end

%% Derived quantities
% ==================================================
delta_sensor_length = -diff(sensor_length);
pedal_x_disp = pedal_x - pedal_x(1);

%% Plot 1: Mechanism movement
figure;
plot(sensor_x, sensor_y, 'DisplayName', 'Sensor Trajectory'); hold on;
plot(pedal_x, pedal_y, 'DisplayName', 'Pedal Trajectory');

plot([sensor_x(1), sensor_axis(1)], ...
     [sensor_y(1), sensor_axis(2)], ...
     'DisplayName', 'Sensor Initial');

plot([sensor_x(end), sensor_axis(1)], ...
     [sensor_y(end), sensor_axis(2)], ...
     'DisplayName', 'Sensor Final');

plot([pedal_x(1), pedal_axis(1)], ...
     [pedal_y(1), pedal_axis(2)], ...
     'DisplayName', 'Pedal Initial');

plot([pedal_x(end), pedal_axis(1)], ...
     [pedal_y(end), pedal_axis(2)], ...
     'DisplayName', 'Pedal Final');

title('Mechanism Movement Diagram');
axis equal;
grid on;
legend('Location','best');


%% Plot 2
figure;
plot(theta_deg, sensor_length);
xlabel('Pedal Angle [deg]');
ylabel('Sensor Length [mm]');
title('Pedal Angle vs Sensor Length');
grid on;


%% Plot 3
figure;
plot(pedal_x_disp, sensor_length);
xlabel('Pedal X Displacement [mm]');
ylabel('Sensor Length [mm]');
title('Pedal X vs Sensor Length');
grid on;


%% Plot 4
figure;
plot(theta_deg(2:end), delta_sensor_length);
xlabel('Pedal Angle [deg]');
ylabel('Sensor Length Change [mm]');
title('Pedal Angle vs Sensor Length Change');
grid on;


%% Plot 5
figure;
plot(pedal_x_disp(2:end), delta_sensor_length);
xlabel('Pedal X Displacement [mm]');
ylabel('Sensor Length Change [mm]');
title('Pedal X vs Sensor Length Change');
grid on;

%% =========================
% Helper function
% =========================
function p_rot = rotate_z(point, theta)
    x = point(1);
    y = point(2);

    p_rot = [
        x * cos(theta) + y * sin(theta), ...
       -x * sin(theta) + y * cos(theta)
    ];
end