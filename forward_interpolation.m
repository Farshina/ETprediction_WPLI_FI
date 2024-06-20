function ETmaps_interpolated = forward_interpolation(imagedates, flight_idx, imagedata, ETc, imagesize, ETmaps_interpolated)
% forward_interpolation: Performs a unidirectional (forward only) variation of the weighted piecewise linear interpolation to gap-fill data between two flight dates, given a reference daily ETc trend.
%
%   ETmaps_interpolated = forward_interpolation(imagedates, flight_idx, imagedata, ETc, imagesize, ETmaps_interpolated)
%   performs a forward interpolation on evapotranspiration (ET) data.
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
%       ETmaps_interpolated = forward_interpolation(imagedates, flight_idx, imagedata, ETc, imagesize, ETmaps_interpolated);
%       See details aboout the input data type and distribution in the generate_dataset.m file.
%
%   Detailed Description:
%       This function performs gap-filling of ET data between two flight dates using a unidirectional (forward only) variation of the weighted piecewise linear interpolation. The interpolation
%       is based on a reference daily ETc trend, ensuring that the interpolated values align with the expected evapotranspiration changes over time.
%
%       The function iterates over each pixel of the image, calculates interpolation weights based on the ETc trend, and fills in the gaps
%       between the provided flight dates. The result is a set of interpolated ET maps that provide a continuous representation of spatial ET
%       between the given flight dates.
%

% Calculate the number of days from the reference date for each flight date
refDate = imagedates(1);
NumDays_flightdays = zeros(1, length(imagedates));
for i = 1:length(imagedates)
    current_date = imagedates(i);
    NumDays_flightdays(i) = daysact(string(refDate), string(current_date)) + 1;
end

% Define the start and end dates for interpolation
start_date = imagedates(flight_idx(1)) + 1; % Start the day after the first flight date
enddate = imagedates(flight_idx(2)); % End on the second flight date
NumDays = daysact(string(refDate), string(start_date)) + 1 : daysact(string(refDate), string(enddate)) + 1; % Calculate the range of days for interpolation

% Retrieve sensor-measured daily ETc values for the interpolation range and flight days
sensor_data_array = ETc(NumDays);
sensor_data_flightdays = ETc(NumDays_flightdays);

% Loop through each pixel in the image
for i = 1:imagesize(1)
    for j = 1:imagesize(2)
        xq = length(NumDays);
        ET_map_q = zeros(1, xq); % Initialize the interpolation array

        for day = 1:xq
            w_sum = 0;
            daydiff = zeros(1, flight_idx(1));
            for k = 1:flight_idx(1) % Only account for the previous flights
                daydiff(k) = NumDays(day) - NumDays_flightdays(k); % Calculate the day difference
                if daydiff(k) ~= 0
                    w_sum = w_sum + (1 / daydiff(k)); % Sum of weights
                end
            end

            ET_map_sum = 0;
            for k = 1:flight_idx(1) % Only account for the previous flights
                ETmap(k) = imagedata{k}(i, j); % Pixel values for previous flight dates
                C(k) = ETmap(k) / sensor_data_flightdays(k); % Proportionality constant
                ET_map_qk = C(k) * sensor_data_array(day); % Approximation from previous flight days
                if daydiff(k) ~= 0
                    w_k = (1 / daydiff(k)) / w_sum; % Weight for the current flight date
                    ET_map_sum = ET_map_sum + w_k * ET_map_qk;
                end
            end

            ET_map_q(day) = ET_map_sum;
            ETmaps_interpolated{NumDays(day)}(i, j) = max(ET_map_q(day), 0); % Ensure non-negative values
        end
    end
end

end
