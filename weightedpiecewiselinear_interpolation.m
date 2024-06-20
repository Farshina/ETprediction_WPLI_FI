function ETmaps_interpolated = weightedpiecewiselinear_interpolation(imagedates, flight_idx, imagedata, ETc, imagesize, ETmaps_interpolated)
% weightedpiecewiselinear_interpolation: Performs a weighted piecewise linear interpolation to gap-fill data between two flight dates, given a reference daily ETc trend.
%
%   ETmaps_interpolated = weightedpiecewiselinear_interpolation(imagedates, flight_idx, imagedata, ETc, imagesize, ETmaps_interpolated)
%   performs a weighted piecewise linear interpolation on evapotranspiration (ET) data.
%
%   Inputs:
%       imagedates - A datetime array representing the dates when the aerial imagery was collected.
%       flight_idx - A two-element vector indicating the indices of the two consecutive flights between which to interpolate.
%       imagedata - A cell array where each cell contains an image matrix from a flight.
%       ETc - A vector representing the daily canopy evapotranspiration trend.
%       imagesize - A two-element vector specifying the image dimensions in pixels (rows, columns).
%       ETmaps_interpolated - A cell array where the interpolated ET maps will be appended.
%
%   Outputs:
%       ETmaps_interpolated - The updated cell array containing the interpolated ET maps.
%
%   Example:
%       ETmaps_interpolated = weightedpiecewiselinear_interpolation(imagedates, flight_idx, imagedata, ETc, imagesize, ETmaps_interpolated);
%       See details aboout the input data type and distribution in the generate_dataset.m file.
%
%   Detailed Description:
%       This function performs gap-filling of ET data between two flight dates using a weighted piecewise linear interpolation. The interpolation
%       is based on a reference daily ETc trend, ensuring that the interpolated values align with the expected evapotranspiration changes over time.
%
%       The function iterates over each pixel of the image, calculates interpolation weights based on the ETc trend, and fills in the gaps
%       between the provided flight dates. The result is a set of interpolated ET maps that provide a continuous representation of spatial ET
%       between the given flight dates.
%

% Extract the start and end dates for interpolation
refDate = imagedates(1);
start_date = imagedates(flight_idx(1));
enddate = imagedates(flight_idx(2));
NumDays = daysact(string(refDate), string(start_date)) + 1 : daysact(string(refDate), string(enddate)) + 1; % Calculate the range of days for interpolation

% Loop through each pixel in the image
for i = 1:imagesize(1)
    for j = 1:imagesize(2)
        % Define the number of days for interpolation
        xq = length(NumDays);

        % Calculate the weight factor for interpolation
        factor = 1 / (xq - 1);
        
        % Retrieve pixel values for the two consecutive flight dates
        ETmap = [imagedata{flight_idx(1)}(i, j), imagedata{flight_idx(2)}(i, j)];
        
        % Retrieve sensor-measured daily ETc values for the target dates, or in between the two above-mentioned consecutive flight dates
        sensor_data = ETc(NumDays);
        
        % Initialize the interpolation arrays
        ET_map_q1 = zeros(1, xq); % Approximation from previous flight day
        ET_map_q2 = zeros(1, xq); % Approximation from next flight day
        ET_map_q = zeros(1, xq);
        
        % Calculate the proportionality constants
        prev_flight_constant = ETmap(1) / sensor_data(1);
        next_flight_constant = ETmap(end) / sensor_data(end);
        
        % Perform the interpolation for each day
        for day = 1:xq
            ET_map_q1(day) = prev_flight_constant * sensor_data(day);
            ET_map_q2(day) = next_flight_constant * sensor_data(day);
            ET_map_q(day) = (ET_map_q1(day) * (1 - (factor * (day - 1)))) + (ET_map_q2(day) * (factor * (day - 1)));
            
            % Append the interpolated value to the output cell array, ensuring non-negative values
            ETmaps_interpolated{NumDays(day)}(i, j) = max(ET_map_q(day), 0); % Data cleaning to avoid negative values
        end
    end
end
end
