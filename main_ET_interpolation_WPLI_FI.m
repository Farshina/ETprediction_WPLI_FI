% main_ET_interpolation_WPLI_FI.m
% This script performs weighted piecewise linear interpolation (WPLI) and forward interpolation (FI)
% on synthetic evapotranspiration (ET) data collected over 43 days with flights every 7 days.

% The script generates synthetic datasets, interpolates ET data between flight dates using two methods,
% and stores the interpolated data in separate cell arrays.

% Author: Farshina Nazrul Shimim
% Date: June 20, 2024

clear all;
close all;
clc;

%% Dataset Generation

% Define a reference date, or the first day when flight is operated. Also min(imagedates)
refdate = datetime('2024-05-26', 'InputFormat', 'yyyy-MM-dd');

% Generate synthetic ET data for 43 days with flights every 7 days. This results in 7 flights in total
[imagedata, imagedates, ETc, imagesize, ndays, flightdays] = generate_dataset(refdate);
%% Weighted Piecewise Linear Interpolation (WPLI)

% Define an empty cell array where the daily interpolated data will be appended.
ETmaps_interpolated_WPLI = {};

% Iterate through flights 1:6 such that the target flights to interpolate between are [1,2], [2,3], ..., [6,7].
for i = 1:length(flightdays)-1
    flight_idx = [i, i+1]; % Indices of consecutive flights to interpolate between
    ETmaps_interpolated_WPLI = weightedpiecewiselinear_interpolation(imagedates, flight_idx, imagedata, ETc, imagesize, ETmaps_interpolated_WPLI);
end

%% Forward Interpolation (FI)

% Define an empty cell array where the daily interpolated data will be appended.
ETmaps_interpolated_FI = {};

% Iterate through flights 1:6 such that the target flights to interpolate between are [1,2], [2,3], ..., [6,7].
for i = 1:length(flightdays)-1
    flight_idx = [i, i+1]; % Indices of consecutive flights to interpolate between
    ETmaps_interpolated_FI = forward_interpolation(imagedates, flight_idx, imagedata, ETc, imagesize, ETmaps_interpolated_FI);
end
