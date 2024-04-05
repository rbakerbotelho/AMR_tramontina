classdef DifferentialDriveModel < matlab.System
    % This block implements the Differential Drive Model for a robot.
    %
    % This template includes the minimum set of functions required
    % to define a System object with discrete state.

    % Public, tunable properties
    properties
        wheel_radius = 1
        wheel_base = 1
        x0 = 0
        y0 = 0
        theta0 = 0
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

        function [angular_speed, speed] = stepImpl(obj,left_wheel_speed, right_wheel_speed, x0)
            % Implement algorithm. Calculate y as a function of input u and
            % discrete states.
            %   angular_speed = obj.wheel_radius/2 * (left_wheel_speed + right_wheel_speed);
            %   speed = obj.wheel_radius/obj.wheel_base * (right_wheel_speed - left_wheel_speed);
            angular_speed = obj.wheel_radius/2 * (left_wheel_speed - right_wheel_speed);
            speed = obj.wheel_radius/obj.wheel_base * (right_wheel_speed + left_wheel_speed);
            obj.theta = obj.theta + angular_speed;
            obj.x = obj.x + speed*cos(obj.theta);
            obj.y = obj.y + speed*sin(obj.theta);
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            obj.theta = 0;
            obj.x = 0;
            obj.y = 0;
        end

    end
end
