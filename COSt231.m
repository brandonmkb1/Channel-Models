clc;
clear;

% User input section
f = input('Enter the frequency in MHz (1500 to 2000 MHz): ');
h_b = input('Enter the base station antenna height in meters (30 to 200 m): ');
h_m = input('Enter the mobile station antenna height in meters (1 to 10 m): ');
d = input('Enter the distance between base station and mobile station in km (1 to 20 km): ');
area_type = input('Enter the area type (urban/suburban/rural): ', 's');

% Input validation
if f < 1500 || f > 2000
    error('Frequency out of range. Must be between 1500 MHz and 2000 MHz.');
end
if h_b < 30 || h_b > 200
    error('Base station antenna height out of range. Must be between 30 m and 200 m.');
end
if h_m < 1 || h_m > 10
    error('Mobile station antenna height out of range. Must be between 1 m and 10 m.');
end
if d < 1 || d > 20
    error('Distance out of range. Must be between 1 km and 20 km.');
end

% Calculate correction factor a(h_m) for urban areas
a_hm = (1.1 * log10(f) - 0.7) * h_m - (1.56 * log10(f) - 0.8);

% Determine area correction factor C
if strcmpi(area_type, 'urban')
    C = 3;  % For metropolitan areas
else
    C = 0;  % For suburban and rural areas
end

% Calculate the path loss using COST 231-Hata model
L_p = 46.3 + 33.9 * log10(f) - 13.82 * log10(h_b) - a_hm + ...
      (44.9 - 6.55 * log10(h_b)) * log10(d) + C;

% Display the result
fprintf('The path loss using the COST 231-Hata model is: %.2f dB\n', L_p);

% Optional: Plotting frequency vs. path loss for a range of frequencies
frequencies = linspace(1500, 2000, 100); % Generate frequencies from 1500 to 2000 MHz
path_loss = zeros(1, length(frequencies));

for i = 1:length(frequencies)
    f_temp = frequencies(i);
    a_hm_temp = (1.1 * log10(f_temp) - 0.7) * h_m - (1.56 * log10(f_temp) - 0.8);
    path_loss(i) = 46.3 + 33.9 * log10(f_temp) - 13.82 * log10(h_b) - a_hm_temp + ...
                   (44.9 - 6.55 * log10(h_b)) * log10(d) + C;
end

figure;
plot(frequencies, path_loss, 'b-', 'LineWidth', 2);
title('COST 231-Hata Model: Frequency vs Path Loss');
xlabel('Frequency (MHz)');
ylabel('Path Loss (dB)');
grid on;
