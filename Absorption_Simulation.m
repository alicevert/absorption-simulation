%% Last updated: 2026-07-02 by Alice Calvert
%% Updated: 2025-02-27 by Raaja rajeshwari Manickam 
%% 2021-08-27 by Kenzie Lewis
%% This is a program to simulate the wavelength-dependent absorption coefficient (alpha)
%% for SnO2 @ Au nanoparticles by changing the core size (b) and shell thickness (d).
%% The input is the shell thickness d.
%% The outputs are the absorption coefficients at each wavelength.
%% The simulation is based off algorithm by Dani et al. [1]
%% All units are SI except the absorption coefficient (cm^-1). Angles are in rads.

%%                                  References
%% [1] R.K. Dani et al., “Supplemental Material for "Faraday rotation enhancement 
%%     of gold coated Fe2O3 nanoparticles: Comparison of experiment and theory” "
%%     J. Chem. Phys, vol. 135, no. 224502, 2011. 
%% [2] A. Ibrahim, “Synthesis and Characterization of Magnetic Nanoparticles 
%%     to Incorporate into Silicon Waveguides to be Used as Optical Isolators,” 
%%     M.S. thesis, Eng. Phys., McMaster Univ., Hamilton, Ontario, 2019. [Online]. Available: https://macsphere.mcmaster.ca/bitstream/11375/24720/2/Ibrahim_Amr_E_201908_MASc.pdf 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [wavelength,absorption]=Absorption_Simulation(core_radius,shell_thickness) 
%The program will starting timing the run.
%tic

%% General Parameters & Constants
c = 3e8;
b = core_radius*10e-9;             % core radius  
d = shell_thickness*10e-9;         % shell thickness
a=b+d;                             % particle radius
Bz=4.2;                            % applied magnetic field along z [T]
B=4.2;                             % applied magnetic field [T]
T=20+273.15;                       % temperature
kb=1.38064852e-23;                 % Boltzmann constant
me=9.10938356e-31;                 % effective mass of electron
e=1.60217662e-19;                  % elementary charge
absorption=[];                         % variable that will store Verdet constant values
mu0=4*pi*1e-7;                     % vacuum permeability
wavelength = 200e-9:1e-9:900e-9;    % wavelength [m]
c_Vs=(4/3)*pi*b^3;                 % particle volume

%% Gold parameters (fitted using 17 nm diameter gold NPs in water)
g_tau=9.1e-15;                     % Scattering time 
vf =1.4e6;                          % Fermi velocity
g_wp=1.37e16;                      % Plasma frequency
g_gammap=(1/g_tau)+(vf/d);         % Damping frequency
g_g0=4.43e15;                      % Fitted parameter for gold absorption [1]
g_w0=3.86e15;                      % Fitted parameter for gold absorption [1]
g_gamma0=6.22e14;                  % Fitted parameter for gold absorption [1]
g_wB=(e*Bz)/me;                    % Cyclotron frequency

%% Effective Medium Parameter (Make sure to change!)
%epsa=1.777;                        %Dielectric function of medium, water
epsa=1.0005;                       %Dielectric function of medium, air
    
% SnO2 Parameters (Make sure to comment out if using Fe2O3 core!) [2]
Keff=5e3;                                   % Effective anisotropy constant, 5-9e3 [2]
Ms=250e3;                                   % Saturation magnetization, 250-300e3 [2]
Bzint=(((2/9)*mu0*c_Vs*Ms^2)/(kb*T))*B;     %Internal magnetic field
c_wp=0;                                     % Plasma frequency
c_gammap = (2.75e14 / (0.347e-15)) + vf / b;        % Damping frequency, change!
c_g0=1.2e15;                                % Fitted parameter for tin oxide absorption 
c_w0=6.7e15;                                % Fitted parameter for tin oxide absorption 
c_gamma0=9e15;                              % Fitted parameter for tin oxide absorption
c_wB=(e*Bzint)/(me);                        % Cyclotron frequency, assuming bulk effective mass of 9.5me^2
c_ns=10e14;                                % Number density
f=c_ns*c_Vs;                                % Volume fraction   

% %% Fe2O3 Parameters (Make sure to comment out if using SnO2 core!) [1]
% Keff=4700;%9e3;                           % Effective anisotropy constant, 5-9e3
% Ms=414e3;%250e3;                          % Saturation magnetization, 250-300e3
% b=4.85e-9;%rc                             % Core radius  
% a=b+d;                                    % Outer radius
% Bzint=(((2/9)*mu0*c_Vs*Ms^2)/(kb*T))*B;   %Internal magnetic field
% c_wp=0;                                   % Plasma frequency
% c_gammap=1/(0.347e-15)+vf/b;              % Damping frequency
% c_g0=5.2e15;                              % Fitted parameter for iron oxide absorption [1]
% c_w0=5.06e15;                             % Fitted parameter for iron oxide absorption [1]
% c_gamma0=2.89e15;                         % Fitted parameter for iron oxide absorption [1]
% c_wB=(e*Bzint)/(me);                      % Cyclotron frequency
% c_ns=3.5e18;                              % Number density
% f=c_ns*c_Vs;                              % Volume fraction
    
for lambda=wavelength
    w=(2*pi*c)/lambda;             %Frequency
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculating gold shell contribution to dielectric function
    % Based off Drude-Sommerfeld Theory [1]
    %% NOTE: interband transitions are neglected.
    %% NOTE: current fitted parameters are for 17 nm diameter gold NPs in water.
    g_tau=9.1e-15;                     % Scattering time
    vf=1.4e6;                          % Fermi velocity
    g_wp=1.37e16;                      % Plasma frequency
    g_gammap=(1/g_tau)+(vf/d);         % Damping frequency
    g_g0=4.43e15;                      % Fitted parameter for gold absorption % CHANGE 
    g_w0=3.86e15;                      % Fitted parameter for gold absorption % CHANGE 
    g_gamma0=6.22e14;                  % Fitted parameter for gold absorption % CHANGE 
    g_wB=(e*Bz)/me;                    % Cyclotron frequency
    
    eps_bL= 1-(g_g0^2)/(w^2-g_w0^2+1i*g_gamma0*w-w*g_wB)-(g_wp^2)/(w^2+1i*g_gammap*w-w*g_wB); %dielectric function, gold, left polarization
    eps_bR= 1-(g_g0^2)/(w^2-g_w0^2+1i*g_gamma0*w+w*g_wB)-(g_wp^2)/(w^2+1i*g_gammap*w+w*g_wB); %dielectric function, gold, right polarization
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculating Fe2O3 core contribution to dielectric function [1]
    eps_cL= 1-(c_g0^2)/(w^2-c_w0^2+1i*c_gamma0*w-w*c_wB); %dielectric function, iron, left polarization
    eps_cR= 1-(c_g0^2)/(w^2-c_w0^2+1i*c_gamma0*w+w*c_wB); %dielectric function, iron, right polarization
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculating core/shell permittivity, epsilonS
    % Based off Maxwell-Garnet Theory, with shell as effective medium [1]
    fc=(b/a)^3;                                   %Volume fraction of core in shell
    betaCL=fc*(eps_cL-eps_bL)/(eps_cL+2*eps_bL);
    betaCR=fc*(eps_cR-eps_bR)/(eps_cR+2*eps_bR);
    epsilonSL=eps_bL*((1+2*betaCL)/(1-betaCL));
    epsilonSR=eps_bR*((1+2*betaCR)/(1-betaCR));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculating effective permittivity, epsilonFinal
    % Based off Maxwell-Garnet Theory, with water medium [1]
    ns=10e14;                                     %number density
    Vs=(4/3)*pi*a^3;                               %particle volume
    fs=ns*Vs;                                      %volume fraction
    betaSL=fs*(epsilonSL-epsa)/(epsilonSL+2*epsa);
    betaSR=fs*(epsilonSR-epsa)/(epsilonSR+2*epsa);
    epsilonFinalL=epsa*(1+2*betaSL)/(1-betaSL);
    epsilonFinalR=epsa*(1+2*betaSR)/(1-betaSR);
    epsilonXX = 0.5*(epsilonFinalR+epsilonFinalL);
    epsilonXY=(1i/2)*(epsilonFinalR-epsilonFinalL);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Calculating Absorption [1]
  
    % Check if this is the first iteration to print the column headers
    if lambda == wavelength(1)
    fprintf('%-15s %-15s', 'AbsorptionLambda', newline);  % Column header
    end

    absorptionLambda = (2 * w / c) * imag(sqrt((epsilonFinalL + epsilonFinalR) / 2));
    absorption(end + 1) = absorptionLambda / 100;  % Append value

    % Display the absorption value
    fprintf('%-15.4e\n', absorptionLambda);  % Display the value in scientific notation

    % Optionally, you can display other information or perform further actions
    
    
    %The program will stop timing the run.
    %toc 
end
end