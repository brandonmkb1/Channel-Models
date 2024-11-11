function okumuraHataModel()
    % Clear workspace and command window
    clc; clear;

    % Get inputs from the user
    f = input('Enter the frequency in MHz (150 to 1500 MHz): ');
    h_b = input('Enter the base station antenna height in meters (30 to 200 m): ');
    h_m = input('Enter the mobile station antenna height in meters (1 to 10 m): ');
    d = input('Enter the distance between base station and mobile station in km (1 to 20 km): ');
    area_type = input('Enter the area type (urban/suburban/rural): ', 's');
    
    % Validate inputs
    if f < 150 || f > 1500
        error('Frequency out of range. It must be between 150 and 1500 MHz.');
    end
    if h_b < 30 || h_b > 200
        error('Base station antenna height out of range. It must be between 30 and 200 meters.');
    end
    if h_m < 1 || h_m > 10
        error('Mobile station antenna height out of range. It must be between 1 and 10 meters.');
    end
    if d < 1 || d > 20
        error('Distance out of range. It must be between 1 and 20 km.');
    end

    % Calculate correction factor a(h_m) for urban area
    a_hm = 3.2 * (log10(11.75 * h_m))^2 - 4.97;

    % Calculate path loss for urban area
    Lp_urban = 69.55 + 26.16 * log10(f) - 13.82 * log10(h_b) - a_hm ...
               + (44.9 - 6.55 * log10(h_b)) * log10(d);
    
    % Adjust path loss for suburban and rural areas
    switch lower(area_type)
        case 'urban'
            Lp = Lp_urban;
        case 'suburban'
            Lp = Lp_urban - 2 * (log10(f / 28))^2 - 5.4;
        case 'rural'
            Lp = Lp_urban - 4.78 * (log10(f))^2 + 18.33 * log10(f) - 40.94;
        otherwise
            error('Invalid area type. Choose urban, suburban, or rural.');
    end

    % Display the result
    fprintf('The path loss using the Okumura-Hata model is: %.2f dB\n', Lp);
end
