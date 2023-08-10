function X_polar = polarPrint(X)

%% Description:
%  X_polar prints the complex number or vector of complex numbers X in
%  format: M<theta, where M is the magnitude and theta is the angle of the
%  complex numbers in degrees.

%% Inputs
%  X: Complex number or vector of complex numbers 

%% Outputs
%  X_polar: String or cell array of strings with the complex numbers X in
%  polar format

    X_mag = abs(X);
    X_angle = angle(X)*180/pi;
    X_polar = arrayfun(@(x1,x2) sprintf('%.6f < %.6f',x1,x2),X_mag,X_angle,'uni',0);
end