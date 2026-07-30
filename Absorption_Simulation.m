%% Last updated: 2026-07-28 by Alice Calvert
%% Updated: 2025-02-27 by Raaja rajeshwari Manickam 
%% 2021-08-27 by Kenzie Lewis
%% This is a program to simulate the wavelength-dependent absorption coefficient (alpha)
%% for SnO2 @ Au nanoparticles by changing the core size (b) and shell thickness (d), which are inputs. 
%% Other inputs are the planar number density [1/m^2], the core material, the dielectric permittivity of the medium in which the 
%% nanoparticles are immersed, the range of wavelengths, and the option of whether to display the alpha values in the command window or not.
%% The outputs are the absorption coefficients at each wavelength.
%% The simulation is based off algorithm by Dani et al. [1]
%% All units are SI except the absorption coefficient [cm^-1]. Angles are in rads.

%% -------------------------------------------------------------------------- %%
%% ------------------------------- References ------------------------------- %%
%% -------------------------------------------------------------------------- %%
%% [1] R.K. Dani et al., "Supplemental Material for 'Faraday rotation enhancement 
%% of gold coated Fe2O3 nanoparticles: Comparison of experiment and theory' "
%%     J. Chem. Phys, vol. 135, no. 224502, 2011. 
%% [2] A. Ibrahim, “Synthesis and Characterization of Magnetic Nanoparticles 
%%     to Incorporate into Silicon Waveguides to be Used as Optical Isolators,” 
%%     M.S. thesis, Eng. Phys., McMaster Univ., Hamilton, Ontario, 2019. [Online]. Available: https://macsphere.mcmaster.ca/bitstream/11375/24720/2/Ibrahim_Amr_E_201908_MASc.pdf 

%% -------------------------------------------------------------------------- %%
%% -------------------------- Absorption Function --------------------------- %%
%% -------------------------------------------------------------------------- %%

function [wavelength,absorption]=Absorption_Simulation(core_radius,shell_thickness,planar_density,core_material,eff_medium,wavelength,display_alpha) 

tic %start timing run

%% General Parameters & Constants

c=3e8;                             % speed of light [m/s]
Bz=0;                              % applied magnetic field along z [T]
B=0;                               % applied magnetic field [T]
T=20+273.15;                       % temperature [K]
kb=1.38064852e-23;                 % Boltzmann constant
me=9.10938356e-31;                 % effective mass of electron [kg]
e=1.60217662e-19;                  % elementary charge
mu0=4*pi*1e-7;                     % vacuum permeability
b = core_radius*10e-9;             % core radius [m]
d = shell_thickness*10e-9;         % shell thickness [m]
c_Vs=(4/3)*pi*b^3;                 % core volume [m^3]
a=b+d;                             % particle radius [m]
Vs=(4/3)*pi*a^3;                   % particle volume [m^3]
fc=(b/a)^3;                        % volume fraction of core in shell

absorption = zeros(size(wavelength));                     % variable that will store absorption constant values

%% -------------------------- Parameters of shell --------------------------- %%

%% Gold parameters (fitted using 17 nm diameter gold NPs in water; interband transitions are neglected)
% Based off Drude-Sommerfeld Theory [1]

g_tau=9.1e-15;                     % scattering time 
vf =1.4e6;                         % Fermi velocity
g_wp=1.37e16;                      % plasma frequency
g_gammap=(1/g_tau)+(vf/d);         % damping frequency
g_g0=4.43e15;                      % fitted parameter for gold absorption [2], CHANGE
g_w0=3.86e15;                      % fitted parameter for gold absorption [2], CHANGE
g_gamma0=6.22e14;                  % fitted parameter for gold absorption [2], CHANGE
g_wB=(e*Bz)/me;                    % cyclotron frequency

%% Effective Medium Parameter (dielectric function of medium)

epsa=eff_medium;

%% --------------------------- Parameters of core --------------------------- %%

if strcmpi(core_material, 'sno2')

    %% Option 1: SnO2 [2]

    Keff=5e3;                                   % effective anisotropy constant, 5-9e3 [2] J/m^2
    Ms=250e3;                                   % saturation magnetization, 250-300e3 [2] A/m
    c_wp=0;                                     % plasma frequency [rad/s]
    c_gammap = (2.75e14/(0.347e-15))+vf/b;      % damping frequency, CHANGE
    c_g0=1.2e15;                                % fitted parameter for tin oxide absorption 
    c_w0=6.7e15;                                % fitted parameter for tin oxide absorption 
    c_gamma0=9e15;                              % fitted parameter for tin oxide absorption  
    c_ns=2.65e5;                                % number density [1/m^3]

elseif strcmpi(core_material, 'fe2o3')
    
    %% Option 2: Fe2O3 [1]

    Keff=4700;%9e3;                           % effective anisotropy constant, 5-9e3 J/m^2
    Ms=414e3;%250e3;                          % saturation magnetization, 250-300e3 A/m
    c_wp=0;                                   % plasma frequency [rad/s]
    c_gammap=1/(0.347e-15)+vf/b;              % damping frequency
    c_g0=5.2e15;                              % fitted parameter for iron oxide absorption [1]
    c_w0=5.06e15;                             % fitted parameter for iron oxide absorption [1]
    c_gamma0=2.89e15;                         % fitted parameter for iron oxide absorption [1]
    c_ns=3.5e18;                              % number density [1/m^3]

elseif strcmpi(core_material, 'other')

    %% Option 3: Other materials

    confirmed = false;
    while ~confirmed

        Keff = input('Enter the average anisotropy constant [J/m^3]:');
        Ms = input('Enter the saturation magnetization [A/m]:');
        c_wp = input('Enter the plasma frequency of free electrons [rad/s]:');
        c_gammap = input('Enter the damping frequency of free electrons [Hz]');
        c_g0 = input('Enter the oscillator strength of bound electrons:');
        c_w0 = input('Enter the binding frequency [Hz] of bound electrons:');
        c_gamma0 = input('Enter the damping frequency [Hz] of bound electrons:');
        c_ns = input('Enter the nanoparticle number density [1/m^3]:');
        
        while true

            should_continue = input('Proceed with entered values? ("yes" or "no"):','s');
    
            if strcmpi(should_continue, 'yes')
                confirmed = true;
                break;
            elseif strcmpi(should_continue, 'no')
                fprintf('Proceeding to re-enter values.\n\n')
                break;
            else
                fprintf('Invalid input. Please enter "yes" or "no".\n\n');
            end

        end

    end

end

c_ns = planar_density/1;                    % number density [1/m^3] = planar density [1/m^2] / 1 m
Bzint=(((2/9)*mu0*c_Vs*Ms^2)/(kb*T))*B;     % internal magnetic field
c_wB=(e*Bzint)/(me);                        % cyclotron frequency, assuming bulk effective mass of 9.5me^2
fs=c_ns*Vs;                                 % volume fraction

%% ---------------------- Wavelength-dependent alpha ------------------------ %%
    
for i = 1:length(wavelength)

    lambda=wavelength(i);
    w=(2*pi*c)/lambda;             %optical fequency
    
    % -------- Gold shell contribution to dielectric function (eps_b) -------- %

    eps_bL= 1-(g_g0^2)/(w^2-g_w0^2+1i*g_gamma0*w-w*g_wB)-(g_wp^2)/(w^2+1i*g_gammap*w-w*g_wB); % dielectric function, gold, left polarization
    eps_bR= 1-(g_g0^2)/(w^2-g_w0^2+1i*g_gamma0*w+w*g_wB)-(g_wp^2)/(w^2+1i*g_gammap*w+w*g_wB); % dielectric function, gold, right polarization
    

    % -------- Core contribution to dielectric function (eps_c) [2] ---------- %

    eps_cL= 1-(c_g0^2)/(w^2-c_w0^2+1i*c_gamma0*w-w*c_wB); % dielectric function, metal oxide, left polarization
    eps_cR= 1-(c_g0^2)/(w^2-c_w0^2+1i*c_gamma0*w+w*c_wB); % dielectric function, metal oxide, right polarization
    
    % ------------------ Core/shell permittivity (eps_s) --------------------- %
    % Based off Maxwell-Garnet Theory, with shell as effective medium [1]
 
    beta_cL=fc*(eps_cL-eps_bL)/(eps_cL+2*eps_bL);
    beta_cR=fc*(eps_cR-eps_bR)/(eps_cR+2*eps_bR);
    eps_sL=eps_bL*((1+2*beta_cL)/(1-beta_cL));
    eps_sR=eps_bR*((1+2*beta_cR)/(1-beta_cR));

   
    % ----------------- Effective permittivity (eps_final) ------------------- %
    % Based off Maxwell-Garnet Theory, with water medium [1]

    beta_sL = fs*(eps_sL-epsa)/(eps_sL+2*epsa);
    beta_sR = fs*(eps_sR-epsa)/(eps_sR+2*epsa);
    eps_finalL = epsa*(1+2*beta_sL)/(1-beta_sL);
    eps_finalR = epsa*(1+2*beta_sR)/(1-beta_sR);
    eps_XX = 0.5*(eps_finalR+eps_finalL);
    eps_XY = (1i/2)*(eps_finalR-eps_finalL);

    % --------------- Absorption coefficient calculation [1] ----------------- %
  
    % Check if this is the first iteration to print the column headers

    absorptionLambda = (2 * w / c) * imag(sqrt(eps_XX));
    absorption(i) = absorptionLambda/100;  %append value

    % Display absorption value
    if strcmpi(display_alpha, 'yes')
        if lambda == wavelength(1)
            fprintf('%-15s %-15s', 'AbsorptionLambda', newline);
        end
        fprintf('%-15.4e\n', absorptionLambda);  %scientific notation
    elseif strcmpi(display_alpha, 'no')
        continue;
    end

end 

toc %stop timing run

end
