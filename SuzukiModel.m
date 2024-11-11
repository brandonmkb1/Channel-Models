clc;
clear all;
close all;

% Define constants
sigma_F_1 = 8; % Standard deviation in dB for part (a)
sigma_F_2 = 10; % Standard deviation in dB for part (b)
mu_1 = 0; % Mean in dB for part (a)
mu_2 = 0; % Mean in dB for part (b)

% Define the range of outage probabilities from 0.01% to 10%
outage_prob = linspace(0.0001, 0.1, 1000);

% Calculate additive margins for Rayleigh and log-normal (large-scale) fading
Rayleigh_margin = @(F) sqrt(2) * erfcinv(2 * F); % Rayleigh margin in dB
Lognormal_margin = @(F, sigma_F) 20 * log10(F) / (sqrt(2) * sigma_F);

% Joint distribution using the Suzuki model (numerical integration)
Suzuki_margin = @(F, sigma_F) sqrt(2 * pi) * integral(@(r) exp(-r.^2 / 2) .* ...
    exp(-((20*log10(r) - mu_1).^2) ./ (2 * sigma_F^2)), 0, inf);

% Part (a): Calculate for sigma_F = 8 dB, mu = 0 dB
sigma_F = sigma_F_1;
mu = mu_1;
additive_margin_a = Rayleigh_margin(outage_prob) + Lognormal_margin(outage_prob, sigma_F);
suzuki_margin_a = arrayfun(@(F) Suzuki_margin(F, sigma_F), outage_prob);

% Part (b): Calculate for sigma_F = 10 dB, mu = 0 dB
sigma_F = sigma_F_2;
mu = mu_2;
additive_margin_b = Rayleigh_margin(outage_prob) + Lognormal_margin(outage_prob, sigma_F);
suzuki_margin_b = arrayfun(@(F) Suzuki_margin(F, sigma_F), outage_prob);

% Calculate the inaccuracies
inaccuracy_a = additive_margin_a - suzuki_margin_a;
inaccuracy_b = additive_margin_b - suzuki_margin_b;

% Plot results for Part (a)
figure;
subplot(2, 1, 1);
plot(outage_prob*100, inaccuracy_a, 'r', 'LineWidth', 1.5);
title('Inaccuracy of Additive Method vs Suzuki Distribution (Part a)');
xlabel('Outage Probability (%)');
ylabel('Inaccuracy (dB)');
grid on;

% Plot results for Part (b)
subplot(2, 1, 2);
plot(outage_prob*100, inaccuracy_b, 'b', 'LineWidth', 1.5);
title('Inaccuracy of Additive Method vs Suzuki Distribution (Part b)');
xlabel('Outage Probability (%)');
ylabel('Inaccuracy (dB)');
grid on;

% Display results
disp('Part (a) - Inaccuracy for additive vs Suzuki (σ_F=8dB, μ=0dB):');
disp(inaccuracy_a);

disp('Part (b) - Inaccuracy for additive vs Suzuki (σ_F=10dB, μ=0dB):');
disp(inaccuracy_b);
