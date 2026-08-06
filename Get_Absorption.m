% Last Updated: 2026-08-05 by Alice Calvert
% This is a script for plotting the wavelength-dependent absorption coefficient (alpha) across different wavelengths.
% The function in Absorption_Simulation is run to get the alpha values for a given core radius (b), shell thickness (d) or particle radius (a).
% Optionally, absorbance (A) may be plotted across different wavelengths for different b and d. 

% ------------------------------------------------------------- %
% ----------------------- Initialization ---------------------- %
% ------------------------------------------------------------- %

close all;  %close previous figures
clc
clear       %clear variables and memory

% ---------------- Define constants & variables --------------- %

colors = {[1, 0.6, 0],'g','b',[0.9 0.3 0.5],[0.6 0.4 0.5]};
styles = {'-','--','-',':','-'};

% Customizable inputs

lambda = input("Enter the range of wavelengths [m] in the format 'start:step:stop':");
x_min = input('Enter the minimum wavelength [nm] to be plotted: ');
x_max = input('Enter the maximum wavelength [nm] to be plotted: ');

while true

    which_medium = input('In which medium are the nanoparticles immersed? ("water", "air", or "other"):', 's');
    if strcmpi(which_medium, 'water')
        epsa=1.777;
        break;
    elseif strcmpi(which_medium, 'air')
        epsa=1.0005;
        break;
    elseif strcmpi(which_medium, 'other')
        epsa=input('Enter the dielectric permittivity of the medium:');
        break;
    else
        fprintf('Invalid input. Please enter "water", "air", or "other".\n\n');
    end

end

while true
    core = input('Enter the nanoparticle core material ("sno2", "fe2o3", or "other"):', 's');
    if strcmpi(core, 'sno2')
        break;
    elseif strcmpi(core, 'fe2o3')
        break;
    elseif strcmpi(core, 'other')
        break;
    else
        fprintf('Invalid input. Please enter "sno2", "fe2o3", or "other".\n\n');
    end
end

n = input("Enter the planar density [1/m^2]:");
B = input("Enter the applied magnetic flux density [T]:");

while true
    display = input('Do you want to display all the absorption coefficient values by wavelength? ("yes" or "no"):','s');
    if strcmpi(display, 'yes')
        break;
    elseif strcmpi(display, 'no')
        break;
    else 
        fprintf('Invalid input. Please enter "yes" or "no".\n\n');
    end
end

% ------------------------------------------------------------- %
% --------- Plot absorption coefficient by wavelength --------- %
% ------------------------------------------------------------- %

% Run the simulation

figure
hold on

% Select the method
while true

    fixed = input('Enter the geometric parameter to hold constant ("b", "d", or "a") : ', 's');

    if strcmpi(fixed, 'b')

        % Method 1: Hold b constant, vary d

        b = input('Enter the core radius [nm] fixed value:');
        d_values = input('Enter the shell thickness [nm] values in square brackets separated by spaces:');
        labels = cell(1,length(d_values));
        
        for i = 1:length(d_values)
                
            d = d_values(i);
    
            [wavelength, absorption] = Absorption_Simulation(b, d, n, core, B, epsa, lambda, display);
    
            wavelength_nm = wavelength * 1e9; %convert to nm
    
            % Peak absorption in visible spectrum
    
            [pks, locs] = findpeaks(absorption, wavelength_nm); %find all peaks
    
            validPeaks = (locs >= x_min) & (locs <= x_max); %filter peak x-range 
    
            pks_valid = pks(validPeaks); %extract valid peaks
            locs_valid = locs(validPeaks);

            color = colors{mod(i-1,length(colors))+1};
            style = styles{mod(i-1,length(styles))+1};
    
            plot(wavelength_nm, absorption, ...
            'Color', color, ...
            'LineStyle', style, ...
            'LineWidth', 1.5 ...
            );
    
            a=b+d; %particle radius [nm]
            labels{i} = sprintf('a=%.1fnm',a);
    
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
        
        title(sprintf('Absorption of core/shell nanoparticles (b=%.1fnm)',b))
        
        break;

    elseif strcmpi(fixed, 'd')

        % Method 2: Hold d constant, vary b

        d = input('Enter the shell thickness [nm] fixed value:');
        b_values = input('Enter the core radius [nm] values in square brackets separated by spaces:');
        labels = cell(1,length(b_values));
        
        for i = 1:length(b_values)
        
            b = b_values(i);
        
            [wavelength, absorption] = Absorption_Simulation(b, d, m, core, B, espa, lambda, display);
        
            wavelength_nm = wavelength * 1e9; %convert to nm
        
            % Peak absorption in visible spectrum
        
            [pks, locs] = findpeaks(absorption, wavelength_nm); %find all peaks
        
            validPeaks = (locs >= x_min) & (locs <= x_max); %filter peak x-range 
        
            pks_valid = pks(validPeaks); %extract valid peaks
            locs_valid = locs(validPeaks);
        
            color = colors{mod(i-1,length(colors))+1};
            style = styles{mod(i-1,length(styles))+1};
            
            plot(wavelength_nm, absorption, ...
                'Color', color, ...
                'LineStyle', style, ...
                'LineWidth', 1.5 ...
                );
        
            a=b+d; %particle radius [nm]
            labels{i} = sprintf('a=%.2fnm',a);
        
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
        
        title(sprintf('Absorption of core/shell nanoparticles (d=%.2fnm)',d))
        
        break;

    elseif strcmpi(fixed, 'a')

        % Method 3: Hold a constant, vary b & d

        a = input('Enter the particle radius a [nm]: ');
        
        while true
            b_or_d = input('Would you like to enter b or d values? ("b" or "d"): ', 's');

            if strcmpi(b_or_d, 'b')
                b_values = input('Enter the core radius values [nm] in square brackets separated by spaces: ');
                d_values = a - b_values;
                break
            
            elseif strcmpi(b_or_d, 'd')
                d_values = input('Enter the shell thickness values [nm] in square brackets separated by spaces: ');
                b_values = a - d_values;
                break

            else
                fprintf('Invalid input. Please enter "b" or "d".\n\n');
            end
        end

        labels = cell(1,length(d_values));

        for i = 1:length(d_values)

            b = b_values(i);
            d = d_values(i);

            [wavelength, absorption] = Absorption_Simulation(b, d, n, core, B, epsa, lambda, display);

            wavelength_nm = wavelength * 1e9; %convert to nm

            % Peak absorption in visible spectrum

            [pks, locs] = findpeaks(absorption, wavelength_nm); %find all peaks

            validPeaks = (locs >= x_min) & (locs <= x_max); %filter peak x-range 

            pks_valid = pks(validPeaks); %extract valid peaks
            locs_valid = locs(validPeaks);

            color = colors{mod(i-1,length(colors))+1};
            style = styles{mod(i-1,length(styles))+1};

            plot(wavelength_nm, absorption, ...
                'Color', color, ...
                'LineStyle', style, ...
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

        title(sprintf('Absorption of core/shell nanoparticles (a=%.1fnm)',a))

        break;

    else 
        fprintf('Invalid input. Please enter "b", "d", or "a".\n\n');
    
    
    end

end

xlabel('Wavelength [nm]');
ylabel('Absorption coefficient (cm^{-1})');
legend(labels, 'Location', 'best');
xlim([x_min x_max]);

hold off;

% % ------------------------------------------------------------- %
% % --------------- Plot absorbance by wavelength --------------- %
% % ------------------------------------------------------------- %
% 
% % Run the simulation
% 
% figure
% hold on
% 
% b = 12
% for d = 1:5
% 
%         [wavelength, absorption] = Absorption_Simulation(b, d, n, core, epsa, lambda, display);
% 
%         wavelength_nm = wavelength * 1e9; %convert to nm
% 
%         % Calculate absorbance from alpha
% 
%         t = 2*(b+d);
%         absorbance = (absorption*t)/2.303;
% 
%         % Peak absorbance in wavelength range
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
% xlabel('Wavelength [nm]')
% ylabel('Absorbance (a.u.)')
% title('Absorption spectrum of SnO_2@Au nanoparticles')
% 
% legend('a=5.9nm','','a=6.9nm', '','a=7.9nm', '','a=8.9nm', '','a=9.9nm', '','location', 'best')
% xlim([x_min x_max])
% 
% hold off