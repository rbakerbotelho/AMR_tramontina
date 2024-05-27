classdef TricycleModel < matlab.System
    % This block implements the Differential Drive Model for a robot.
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
        wheel_radius = 1
        vehicle_track = 1
        vehicle_wheelbase = 1
        x0 = 0
        y0 = 0
        theta0 = 0
        steering_wheel_radius = 1;
    end

    properties (DiscreteState)
        x
        y
        theta

    end

    % Pre-computed constants
    properties (Access = private)

    end

    methods (Access = protected)
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants

        end

        function [angular_speed, speed] = stepImpl(obj, front_wheel_speed, steering_angle, x0)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            %   angular_speed = obj.wheel_radius/2 * (left_wheel_speed + right_wheel_speed);
            %   speed = obj.wheel_radius/obj.wheel_base * (right_wheel_speed - left_wheel_speed);

            % angular_speed = obj.wheel_radius/2 * (left_wheel_speed - right_wheel_speed);
            speed = front_wheel_speed * cosd(steering_angle);
            angular_speed = speed/obj.vehicle_wheelbase * tand(steering_angle);
            
            obj.theta = obj.theta + angular_speed;
            obj.x = obj.x + speed*cosd(obj.theta);
            obj.y = obj.y + speed*sind(obj.theta);
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            obj.theta = 0;
            obj.x = 0;
            obj.y = 0;
        end

    end
end
