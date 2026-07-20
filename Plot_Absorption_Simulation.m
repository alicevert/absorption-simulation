% 2026-07-02 by Alice Calvert
% This is a script for plotting the wavelength-dependent absorption
% coefficient (alpha) across different wavelengths.
% Runs the function Absorption_Simulation first to get the alpha values for
% a given core radius (b) and shell thickness (d).
% This script also plots absorbance (A) across different wavelengths, to
% verify that for a given b, d, the peaks for A and alpha occur at the same wavelength. 

% ------------------------------------------------------------- %
% ----------------------- Initialization ---------------------- %
% ------------------------------------------------------------- %
close all;  %close previous figures
clc
clear       %clear variables and memory

% Define constants & variables
colors = {[1, 0.6, 0],'g','b',[0.9 0.3 0.5],[0.6 0.4 0.5]};
styles = {'-','--','-',':','-'};
x_min = 450; %min value of wavelength (nm) to be plotted
x_max = 600; %max value of wavelength (nm)  to be plotted

% ------------------------------------------------------------- %
% --------- Plot absorption coefficient by wavelength --------- %
% ------------------------------------------------------------- %

% Run the simulation
figure
hold on

%% Method 1: Hold b constant, vary d (comment out Methods 2,3)

% b = 12.25; %nm
% d_values = [2.65, 2.7, 2.75, 2.8, 2.85]; %nm
% labels = cell(1,length(d_values))
% 
% for i = 1:length(d_values)
% 
%         d = d_values(i)
% 
%         [wavelength, absorption] = Absorption_Simulation(b, d);
% 
%         wavelength_nm = wavelength * 1e9; %convert to nm
% 
%         % Peak absorption in visible spectrum
% 
%         [pks, locs] = findpeaks(absorption, wavelength_nm); %find all peaks
% 
%         validPeaks = (locs >= x_min) & (locs <= x_max); %filter peak x-range 
% 
%         pks_valid = pks(validPeaks); %extract valid peaks
%         locs_valid = locs(validPeaks);
% 
%         plot(wavelength_nm, absorption, ...
%         'Color', colors{i}, ...
%         'LineStyle', styles{i}, ...
%         'LineWidth', 1.5 ...
%         );
% 
%         a=b+d; %particle radius (nm)
%         labels{i} = sprintf('a=%.1fnm',a);
% 
%         plot(locs_valid, pks_valid, ...
%             'ro','MarkerSize',5, 'MarkerFaceColor','r', ...
%             'HandleVisibility', 'off' ...
%             );
% 
%         for k = 1:length(pks_valid)        %label each peak
% 
%             text(locs_valid(k)+5, pks_valid(k), ...
%                 sprintf('%.0f nm', locs_valid(k)), ...
%                 'FontSize', 9 ...
%                 );
%         end
% 
% end
% 
% xlabel('Wavelength (nm)')
% ylabel('Absorption coefficient (cm^{-1})')
% title(sprintf('Absorption of SnO_2@Au nanoparticles (b=%.1fnm)',b))
% 
% legend(labels, 'Location', 'best')
% xlim([x_min x_max])
% 
% hold off

%% Method 2: Hold d constant, vary b (comment out Methods 1,3)

% b_values = [12.15, 12.2, 12.25, 12.3, 12.35]; %nm
% d = 2.75 %nm
% 
% labels = cell(1,length(b_values))
% 
% for i = 1:length(b_values)
% 
%     b = b_values(i)
% 
%     [wavelength, absorption] = Absorption_Simulation(b, d);
% 
%     wavelength_nm = wavelength * 1e9; %convert to nm
% 
%     % Peak absorption in visible spectrum
% 
%     [pks, locs] = findpeaks(absorption, wavelength_nm); %find all peaks
% 
%     validPeaks = (locs >= x_min) & (locs <= x_max); %filter peak x-range 
% 
%     pks_valid = pks(validPeaks); %extract valid peaks
%     locs_valid = locs(validPeaks);
% 
%     plot(wavelength_nm, absorption, ...
%         'Color', colors{i}, ...
%         'LineStyle', styles{i}, ...
%         'LineWidth', 1.5 ...
%         );
% 
%     a=b+d; %particle radius (nm)
%     labels{i} = sprintf('a=%.2fnm',a);
% 
%     plot(locs_valid, pks_valid, ...
%         'ro','MarkerSize',5, 'MarkerFaceColor','r', ...
%         'HandleVisibility', 'off' ...
%         );
% 
%     for k = 1:length(pks_valid)        %label each peak
% 
%         text(locs_valid(k)+5, pks_valid(k), ...
%             sprintf('%.0f nm', locs_valid(k)), ...
%             'FontSize', 9 ...
%             );
%     end
% 
% end
% 
% xlabel('Wavelength (nm)')
% ylabel('Absorption coefficient (cm^{-1})')
% title(sprintf('Absorption of SnO_2@Au nanoparticles (d=%.2fnm)',d))
% 
% legend(labels, 'Location', 'best')
% xlim([x_min x_max])
% 
% hold off

%% Method 3: Hold a constant, vary b & d (comment out Methods 1,2)

a = 14.9 %particle radius (nm)
b_values = [12.45 12.4 12.35]; %nm
d_values = [2.45 2.5 2.55]; %nm
labels = cell(1,length(d_values))

for i = 1:length(d_values)

    b = b_values(i)
    d = d_values(i)

    [wavelength, absorption] = Absorption_Simulation(b, d);

    wavelength_nm = wavelength * 1e9; %convert to nm

    % Peak absorption in visible spectrum

    [pks, locs] = findpeaks(absorption, wavelength_nm); %find all peaks

    validPeaks = (locs >= x_min) & (locs <= x_max); %filter peak x-range 

    pks_valid = pks(validPeaks); %extract valid peaks
    locs_valid = locs(validPeaks);

    plot(wavelength_nm, absorption, ...
        'Color', colors{i}, ...
        'LineStyle', styles{i}, ...
        'LineWidth', 1.5 ...
        );

    labels{i} = sprintf('d=%.2fnm',d);

    plot(locs_valid, pks_valid, ...
        'ro','MarkerSize',5, 'MarkerFaceColor','r', ...
        'HandleVisibility', 'off' ...
        );

    for k = 1:length(pks_valid)        %label each peak

        text(locs_valid(k)+5, pks_valid(k), ...
            sprintf('%.0f nm', locs_valid(k)), ...
            'FontSize', 9 ...
            );
    end

end

xlabel('Wavelength (nm)')
ylabel('Absorption coefficient (cm^{-1})')
title(sprintf('Absorption of SnO_2@Au nanoparticles (a=%.1fnm)',a))

legend(labels, 'Location', 'best')
% ylim([0 5])
xlim([x_min x_max])

hold off

% % ------------------------------------------------------------- %
% % --------------- Plot absorbance by wavelength --------------- %
% % ------------------------------------------------------------- %
% 
% Note: A peaks at same wavelengths as alpha peaks for given b, d
% 
% % Run the simulation
% figure
% hold on
% 
% for d = 1:5
% 
%         [wavelength, absorption] = Absorption_Simulation(b, d);
% 
%         % Convert wavelength from metres to nanometres
%         wavelength_nm = wavelength * 1e9;
% 
%         % Calculate absorbance from alpha
%         t = 2*(b+d);
%         absorbance = (absorption*t)/2.303;
% 
%         % Peak absorbance in visible spectrum
% 
%         [pks, locs] = findpeaks(absorbance, wavelength_nm); %find all peaks
% 
%         validPeaks = (locs >= x_min) & (locs <= x_max); %filter peak x-range 
% 
%         pks_valid = pks(validPeaks); %extract valid peaks
%         locs_valid = locs(validPeaks);
% 
%         plot( ...
%             wavelength_nm, absorbance, ...
%             'Color', colors{d}, ...
%             'LineStyle', styles{d}, ...
%             'LineWidth', 1.5 ...
%             );
% 
%         plot(locs_valid, pks_valid, ...
%             'ro','MarkerSize',5, 'MarkerFaceColor','r');
% 
%         for k = 1:length(pks_valid)        %label each peak
% 
%             text(locs_valid(k)+5, pks_valid(k), ...
%                 sprintf('%.0f nm', locs_valid(k)), ...
%                 'FontSize', 9);
%         end
% end
% 
% xlabel('Wavelength (nm)')
% ylabel('Absorbance (a.u.)')
% title('Absorption spectrum of SnO_2@Au nanoparticles')
% 
% legend('a=5.9nm','','a=6.9nm', '','a=7.9nm', '','a=8.9nm', '','a=9.9nm', '','location', 'best')
% % ylim([0 5])
% xlim([x_min x_max])
% 
% hold off