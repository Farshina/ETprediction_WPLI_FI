function [imagedata, imagedates, ETc, imagesize, ndays, flightdays] = generate_dataset(refdate)
% generate_dataset: Generates synthetic ET data for testing interpolation methods.
%
%   Inputs:
%       refdate - The reference date, or the first day when flight is operated.
%
%   Outputs:
%       imagedata - A cell array containing synthetic flight images.
%       imagedates - A datetime array of the dates when the images were collected.
%       ETc - A vector representing the daily canopy evapotranspiration trend.
%       imagesize - A two-element vector specifying the image dimensions in pixels (rows, columns).
%       ndays - Total number of days in the dataset.
%       flightdays - Indices of days when flights are operated.

    rng(0); % Controlled random number generator

    % Define total number of days and the days when a flight is operated
    ndays = 43;
    flightdays = 1:7:43;

    % Define image dimension in pixels
    imagesize = [100, 50];

    % Create artificial flight images
    ETstd = 0.05; % Standard deviation: 0.05 mm hr^-1
    ETmean = 0.3; % Mean: 0.3 mm hr^-1
    imagedata = cell(1, length(flightdays));
    for i = 1:length(flightdays)
        imagedata{i} = ETstd .* rand(imagesize) + ETmean;
    end

    % Based on the reference date, calculate all other flight dates 
    imagedates = refdate + (flightdays - 1);

    % Define the daily ETc for the range of dates using the formula r = a + (b-a) .* rand(N,1)
    a = 0.2; % Lowest ETc: 0.2 mm hr^-1
    b = 0.4; % Highest ETc: 0.4 mm hr^-1
    ETc = a + (b - a) .* rand(ndays, 1);

end
