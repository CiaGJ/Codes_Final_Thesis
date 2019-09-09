function [Signal,PowerW,PowerdBm,SpotDiameter,SolidAngleArea]=PirometerDob(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Dob,Distance,DistanceConnector,Length,Temperature,Emissivity)

%%
% VERSION CHANGES (Please, add all new changes using a ordered list)
%
% Version 7 (Febraury 27th,2019 - Lucía García):
%   1. Create function for Losses, Acceptance Angle and Responsivity.
%   2. In the FunctionAcceptanceAngle I add a fuction taking into account
%   that the Spot Diameter could be smaller than the Acceptance Angle Area.
%   In case that the Spot Diameter is smaller, is not possible to make the
%   operations with Mean='Off'.
%   3. 
%
% Version 6 (August 20th, 2018 - Alberto Tapetado)
%   1. New comments to describe the meaning of each input variable.
%   2. Added an application examples for both measuring channels.
%   3. Added the reference of the Sellmeier coefficients for a graded-index glass-based multimode optical fiber
%   4. Added the reference of the solid angle calculation.

fprintf('\n');

%%
%**************************************************************************
%   PARAMETERS USED
%**************************************************************************

%       Mean: 'On', 'Off'
%       NOTE:
%       This value represents a digital switch to choose between an
%       approximated or exactcalculation of all integral expressions. The more accurate method
%       uses the the symbolic toolbox of Matlab.
%       Important Note: symbolic method (mean = off) takes more time than
%       the approximated method and I could appreciate no significant difference between their errors.

%       Losses: 'On', 'Off'
%       NOTE:
%       This value represent a logic switch to select if you want to take into account
%       the insertion losses of all opto-electronics devices which take
%       part in the experimental setup.

%       PdMaterial: 'InGaAs', 'InGaAsEx', 'Ge', 'Si', 'PbS', 'PbSe'
%       NOTE:
%       This parameter represents the material of your photodetector. This simulation can
%       be run using different photodetectors although we always use InGaAs photodetectors.
%       I codded this improvement because once upon a time we were studding the performance
%       of the fiber-optic pyrometer using different photodetector responsivities.

%       LambdaUpper = 1700 (1550nm Channel) or 1379um (1310nm Channel)
%       LambdaLower = 1430 (1550nm Channel) or 0800um (1310nm Channel)
%       NOTE:
%       These parameters represent the upper and lower wavelength limits of the
%       wavelength band that you want to simulate, in microns. You must run
%       this simulation programn as many times as number of channels you
%       have. If you have two channels, as it's our case (1310 and 1550nm), you'll
%       run the program two times.

%       Please, pay attention to the upper wavelength value of the 1550nm
%       channel (1700nm) and the lower wavelength value of the 1310nm
%       channel (800nm). Are these value familiar to you? These values
%       corresponds to the upper and lower limits of a InGaAs
%       photodetector. Why? It's easy, our fiber-optic filter works
%       as a high-pass or low-pass filter, this behaviour depends on the filter output you choose.
%       So, the wavelength range of the fiber-optic pyrometer is strongly limited by the
%       wavelength limits of the photodetector responsivity, see the
%       Characterization Responsivities sheet of my Excel document (Summary.xlsx)

%       Diameter = 62.5 +/-3 um (recommended tolerance)
%       NOTE:
%       This parameter represents the diameter of the optical fiber used to
%       gather the radiation in microns. The tolerance represents the minimum and
%       maximum fiber diameter. Practically, you ought to measure the fiber
%       diameter and then you insert that value here.

%       Distance = 0.3 +/-0.075 mm (recommended tolerance)
%       NOTE:
%       This value represents the distance between the fiber end and the
%       hot surface in millimetres. You can also include the tolerance of
%       your measurement.

%       DistanceConnector = 4 - 9.3 mm
%       NOTE:
%       This value represents the distance between the fiber end and the
%       photodetector surface in millimetres. This value is normally fixed by the
%       mechanical structure of your photodetector. I recommend you to read
%       your photodetector datasheet for more information.

%       Length = 0.5 m
%       NOTE:
%       This value represents the length of the optical fiber in metres.

%       Temperature = 650ºC
%       NOTE:
%       This value represents the temperature of the hot surface in Celsius
%       degrees

%       Emissivity = 1 (NOTE: Blackbody emissivity is equal at 1)
%       NOTE:
%       This value represents the emissivity of the hot surface measured by
%       the optical fiber. This value is a dimensionless unit.

%       DATASHEETS:
%       Agilent 81635A: https://literature.cdn.keysight.com/litweb/pdf/5988-1569EN.pdf?id=117914

%%
%**************************************************************************
%   EXAMPLE OF THE INPUT VALUES OF THE PYROMETER FUNCTION FOR A 1550NM CHANNEL
%**************************************************************************

%       Mean: 'Off'
%       Losses: 'On'
%       PdMaterial: 'InGaAs'
%       LambdaUpper = 1700
%       LambdaLower = 1430
%       Diameter = 62.5
%       Distance = 0.3
%       DistanceConnector = 4
%       Length = 0.5
%       Temperature = 650
%       Emissivity = 1

%       FUNCTION STRUCTURE:
%       [Signal,PowerW,PowerdBm]=Pirometer5('Off','On','InGaAs',1700,1430,62.5,0.3,4,0.5,650,1)

%%
%**************************************************************************
%   EXAMPLE OF THE INPUT VALUES OF THE PYROMETER FUNCTION FOR A 1310NM CHANNEL
%**************************************************************************

%       Mean: 'Off'
%       Losses: 'On'
%       PdMaterial: 'InGaAs'
%       LambdaUpper = 1430
%       LambdaLower = 800
%       Diameter = 62.5
%       Distance = 0.3
%       DistanceConnector = 4
%       Length = 0.5
%       Temperature = 650
%       Emissivity = 1

%       FUNCTION STRUCTURE:
%       [Signal,PowerW,PowerdBm]=Pirometer5('Off','On','InGaAs',1430,800,62.5,0.3,4,0.5,650,1)


%%
%**************************************************************************
%   PROGRAM
%**************************************************************************

%%
%**************************************************************************
%   PROGRAM SETTINGS AND UNIT CONVERSIONS
%**************************************************************************

%FORMAT NUMBER
format shortEng

%UNITS CONVERSION.
Temperature=Temperature+273.15;             %Convert: ºC    ->  K
Distance=Distance*1e-3;                     %Convert: mm    ->  m
DistanceConnector=DistanceConnector*1e-3;   %Convert: mm    ->  m
Diameter=Diameter*1e-6;                     %Convert: um    ->  m
LambdaLower=LambdaLower*1e-9;               %Convert: nm    ->  m
LambdaUpper=LambdaUpper*1e-9;               %Convert: nm    ->  m
Length=Length*1e-3;                         %Convert: m     ->  km
Dob=Dob*1e-6;                               %Convert: um    ->  m

%%
%**************************************************************************
%   ACEPTANCE ANGLE & SOLID ANGLE FOR OT = ONA and rT > rNA
%**************************************************************************

[SolidAngleArea,SpotDiameter,AceptanceAngle]=FunctionAcceptanceAngle(Mean,LambdaUpper,LambdaLower,Diameter,Distance,Dob);


%%
%**************************************************************************
%   RESPONSIVITY
%**************************************************************************

%RESPONSIVITY OF THE PHOTODETECTOR'S MATERIAL.
[Responsivity,CouplingEfficience]=FunctionResponsivity(PdMaterial,Diameter,DistanceConnector,AceptanceAngle);

%%
%**************************************************************************
%   INSERTION LOSSES
%**************************************************************************

% Insertion Losses. FC Adaptor, WDM Filter and Silica Fiber.
[SystemLosses,~]=FunctionLosses(Losses,PdMaterial,LambdaUpper,LambdaLower,Length);


%%
%***********************************************************************************
%   PLANCK FUNCTION
%***********************************************************************************

[Signal,Power]=FunctionPlanck(Responsivity,Emissivity,Temperature,SolidAngleArea,LambdaLower,LambdaUpper,PdMaterial);


%%
%**************************************************************************
%   COMPUTING LOSSES IN PLANCK FUNCTION
%**************************************************************************

[Signal,PowerW,PowerdBm]=FunctionPlanckLosses(Power,Signal,SystemLosses,CouplingEfficience,PdMaterial,Mean);


end