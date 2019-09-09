function [Signal,PowerW,PowerdBm]=Pirometer6(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Distance,DistanceConnector,Length,Temperature,Emissivity)

%% 
% VERSION CHANGES (Please, add all new changes using a ordered list)
%
% Version 7:
%   1. ¿?
%   2. ¿?
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
%       I codded this improvement because one upon a time we were studding the performance
%       of the fiber-optic pyrometer using different photodetector responsivities.

%       LambdaUpper = 1700 (1550nm Channel) or 1430um (1310nm Channel)
%       LambdaLower = 1379 (1550nm Channel) or 0800um (1310nm Channel)
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

%CONSTANTS.
h=6.626068e-34;
k=1.38066e-23;
c=2.997925e+8;

%UNITS CONVERSION.
Temperature=Temperature+273.15;             %Convert: ºC    ->  K
Distance=Distance*1e-3;                     %Convert: mm    ->  m
DistanceConnector=DistanceConnector*1e-3;   %Convert: mm    ->  m
Diameter=Diameter*1e-6;                     %Convert: um    ->  m
LambdaLower=LambdaLower*1e-9;               %Convert: nm    ->  m
LambdaUpper=LambdaUpper*1e-9;               %Convert: nm    ->  m
Length=Length*1e-3;                         %Convert: m     ->  km

%VARIABLES
syms Lambda r u Phi Theta



%% 
%**************************************************************************
%   RESPONSIVITY
%**************************************************************************

%RESPONSIVITY OF THE PHOTODETECTOR'S MATERIAL.
if strcmp(PdMaterial,'Si')
    %RESPONSIVITY Si
    fprintf('RESPONSIVITY Si\n\n');
    load('ResponsivityValuesSi.mat')
    load('WavelengthValuesSi.mat')
    Curve=polyfit(WavelengthValuesSi,ResponsivityValuesSi,14);
    Responsivity=poly2sym(Curve,Lambda);
else
    if strcmp(PdMaterial,'Ge')
        %RESPONSIVITY Ge
        fprintf('RESPONSIVITY Ge\n\n');
        load('ResponsivityValuesGe.mat')
        load('WavelengthValuesGe.mat')
        Curve=polyfit(WavelengthValuesGe,ResponsivityValuesGe,13);
        Responsivity=poly2sym(Curve,Lambda);
    else
        if strcmp(PdMaterial,'InGaAsEx')
            %RESPONSIVITY InGaAs Extended
            fprintf('RESPONSIVITY InGaAs EXTENDED\n\n');
            load('ResponsivityValuesInGaAsEx.mat')
            load('WavelengthValuesInGaAsEx.mat')
            Curve=polyfit(WavelengthValuesInGaAsEx,ResponsivityValuesInGaAsEx,15);
            Responsivity=poly2sym(Curve,Lambda);
        else
            if strcmp(PdMaterial,'PbS')
                %RESPONSIVITY PbS
                fprintf('RESPONSIVITY PbS\n\n');
                load('ResponsivityValuesPbS.mat')
                load('WavelengthValuesPbS.mat')
                Curve=polyfit(WavelengthValuesPbS,ResponsivityValuesPbS,8);
                Responsivity=poly2sym(Curve,Lambda);
            else
                if strcmp(PdMaterial,'PbSe')
                    %RESPONSIVITY PbSe
                    fprintf('RESPONSIVITY PbSe\n\n');
                    load('ResponsivityValuesPbSe.mat')
                    load('WavelengthValuesPbSe.mat')
                    Curve=polyfit(WavelengthValuesPbSe,ResponsivityValuesPbSe,10);
                    Responsivity=poly2sym(Curve,Lambda);
                else              
                    %RESPONSIVITY InGaAs
                    fprintf('RESPONSIVITY InGaAs\n\n');
                    load('Data/ResponsivityValuesInGaAs.mat')
                    load('Data/WavelengthValuesInGaAs.mat')
                    Curve=polyfit(WavelengthValuesInGaAs,ResponsivityValuesInGaAs,12);
                    Responsivity=poly2sym(Curve,Lambda);
                end
            end
        end
    end
end



%% 
%**************************************************************************
%   INSERTION LOSSES
%**************************************************************************

if strcmp(Losses,'On')
    if or(strcmp(PdMaterial,'PbSe'),strcmp(PdMaterial,'PbS'))
        fprintf('INSERTION LOSSES: 600nm (PbS) to 4900nm (PbSe)\n');
        AdaptorLosses=1;
        WDMLosses=1;
        FiberLosses=10^((-450*Length)/10);
    else
        fprintf('INSERTION LOSSES: 200nm (Si) to 2640nm (InGaAsEx)\n');
        % Mean of both wavelengths
        MeanLambda=(LambdaUpper-LambdaLower)/(2)+LambdaLower;
        % Insertion Losses. FC Adaptor
        AdaptorLosses=10^(-4/10);
        % Insertion Losses. WDM Filter
        if MeanLambda<1200*1e-9
            WDMLosses=10^((-0.210324967)/10);
        else
            WDMLosses=10^((-0.06590055)/10);
        end
        % Insertion Losses. Silica Fiber
        if MeanLambda<1200*1e-9
            FiberLosses=10^((-0.58*Length)/10);
        else
            FiberLosses=10^((-0.28*Length)/10);
        end
    end
else
    fprintf('INSERTION LOSSES Off\n\n');
    AdaptorLosses=1;
    WDMLosses=1;
    FiberLosses=1;
end
SystemLosses=FiberLosses*WDMLosses*AdaptorLosses;
SystemLossesdB=abs(10*log10(SystemLosses));
fprintf('System Insertion Losses:                       %d      []\n',SystemLosses);
fprintf('System Insertion Losses:                       %d      [dB]\n\n',SystemLossesdB);



%% 
%**************************************************************************
%   ACEPTANCE ANGLE
%**************************************************************************

fprintf('ACEPTANCE ANGLE:\n');
% SELLMEIER COEFFICIENTS OF A SILICA FIBER
% Fiber: Graded-index glass-based multimode optical fiber with a SiO2 core doped with 6.3mol-% GeO2and a SiO2 cladding
% Reference: D. S. Montero, "Multimode Fibre Broadband Access and Self-Referencing Sensor Networks," Electronics Technlogy Department, Universidad Carlos III de Madrid, Leganés (Spain), 2011.

A11=0.7083952; A12=0.4203993; A13=0.8663412; L11=0.0853842; L12=0.1024838; L13=9.8961750;
A21=0.6965325; A22=0.4083099; A23=0.8968766; L21=0.0660932; L22=0.11811007; L23=9.8961604;

if strcmp(Mean,'Off')
    % ACEPTANCE ANGLE AS A FUNCTION OF THE WAVELENGTH
    i=1;
    AceptanceAngleVector=zeros(1);
    LambdaVector=zeros(1);
    for LambdaEval=LambdaLower:0.25e-9:LambdaUpper
        ncore=double((1+((A11*(LambdaEval*1e+6)^2)/((LambdaEval*1e+6)^2-L11^2))+((A12*(LambdaEval*1e+6)^2)/((LambdaEval*1e+6)^2-L12^2))+((A13*(LambdaEval*1e+6)^2)/((LambdaEval*1e+6)^2-L13^2)))^(1/2));
        ncladding=double((1+((A21*(LambdaEval*1e+6)^2)/((LambdaEval*1e+6)^2-L21^2))+((A22*(LambdaEval*1e+6)^2)/((LambdaEval*1e+6)^2-L22^2))+((A23*(LambdaEval*1e+6)^2)/((LambdaEval*1e+6)^2-L23^2)))^(1/2));
        NA=sqrt(ncore^2-ncladding^2);
        AceptanceAngleVector(i)=asin(NA);
        LambdaVector(i)=LambdaEval;
        i=i+1;
    end
    AceptanceAngleVector=AceptanceAngleVector';
    LambdaVector=LambdaVector';
    Coefficients=polyfit(LambdaVector,AceptanceAngleVector,4);
    AceptanceAngle=poly2sym(Coefficients,Lambda);
    AceptanceAngle=simplify(AceptanceAngle);
    fprintf('Numerical Aperture:                            No value        \n');
    fprintf('Aceptance Angle:                               No value        \n');
    fprintf('Spot Diameter:                                 No value        \n\n');
else
    % NUMERICAL APERTURE USING THE MEAN OF BOTH WAVELENGTHS
    LambdaMean=(LambdaUpper+LambdaLower)/(2);
    ncoreMean=(1+((A11*(LambdaMean*1e+6)^2)/((LambdaMean*1e+6)^2-L11^2))+((A12*(LambdaMean*1e+6)^2)/((LambdaMean*1e+6)^2-L12^2))+((A13*(LambdaMean*1e+6)^2)/((LambdaMean*1e+6)^2-L13^2)))^(1/2);
    ncladdingMean=(1+((A21*(LambdaMean*1e+6)^2)/((LambdaMean*1e+6)^2-L21^2))+((A22*(LambdaMean*1e+6)^2)/((LambdaMean*1e+6)^2-L22^2))+((A23*(LambdaMean*1e+6)^2)/((LambdaMean*1e+6)^2-L23^2)))^(1/2);
    NAMean=sqrt(ncoreMean^2-ncladdingMean^2);
    fprintf('Numerical Aperture:                            %d      []\n',NAMean);

    % ACEPTANCE ANGLE USING THE MEAN OF BOTH WAVELENGTHS
    AceptanceAngleMean=asin(NAMean);
    fprintf('Aceptance Angle:                               %d      [º]\n',AceptanceAngleMean);

    % MEASURING AREA COVERED BY THE ACEPTANCE ANGLE USING THE MEAN OF THE WAVELENGTHS
    SpotDiameterMean=(Distance*tan(AceptanceAngleMean)+Diameter/2)*2;
    fprintf('Spot Diameter:                                 %d      [mm]\n\n',SpotDiameterMean*1000);
end



%% 
%**************************************************************************
%   SOLID ANGLE FOR OT = ONA and rT > rNA
%**************************************************************************

% Reference: T. Ueda, A. Hosokawa, and A. Yamamoto, "Studies on Temperature
% of Abrasive Grains in Grinding—Application of Infrared Radiation Pyrometer,
% " Journal of Manufacturing Science and Engineering, vol. 107, pp. 127-133, 1985.

fprintf('SOLID ANGLE:\n');
if strcmp(Mean,'Off')
    % SOLID ANGLE USING THE MEAN OF THE WAVELENGTHS
    SolidAngleArea=((pi^2*(Diameter^2))/(8))*(1-cos(2*AceptanceAngle));
    fprintf('Solid Angle:                                   No value        \n\n');
else
    % SOLID ANGLE AS A FUNCTION OF THE WAVELENGTH
    SolidAngleAreaMean=((pi^2*(Diameter^2))/(8))*(1-cos(2*AceptanceAngleMean));
    fprintf('Solid Angle:                                   %d      [Sr*m^2]\n\n',SolidAngleAreaMean);
end



%% 
%***********************************************************************************
%   PLANCK FUNCTION
%***********************************************************************************

fprintf('PLANCK FUNCTION:\n');
if strcmp(Mean,'Off')
    % PLANCK FUNCTION AS A FUNCTION OF THE WAVELENGTH
    SignalExact=double(int(   ((Responsivity*Emissivity*2*h*c^2) / (Lambda^5*(exp((h*c)/(k*Lambda*Temperature)))))*SolidAngleArea   ,'Lambda',LambdaLower,LambdaUpper) );
    if or(strcmp(PdMaterial,'PbSe'),strcmp(PdMaterial,'PbS'))
        fprintf('Pyrometer Signal:                              %d      [V]\n',SignalExact);
    else
        fprintf('Pyrometer Signal:                              %d      [A]\n',SignalExact);
    end
    PowerExact=double(int(   ((Emissivity*2*h*c^2) / (Lambda^5*(exp((h*c)/(k*Lambda*Temperature)))))*SolidAngleArea   ,'Lambda',LambdaLower,LambdaUpper) );
    fprintf('Power (W):                                     %d      [W]\n\n',PowerExact)
else
    % PLANCK FUNCTION USING THE MEAN OF THE WAVELENGTHS.
    SignalMean=double(int(   ((Responsivity*Emissivity*2*h*c^2) / (Lambda^5*(exp((h*c)/(k*Lambda*Temperature)))))*SolidAngleAreaMean   ,'Lambda',LambdaLower,LambdaUpper) );
    if or(strcmp(PdMaterial,'PbSe'),strcmp(PdMaterial,'PbS'))
        fprintf('Pyrometer Signal:                              %d      [V]\n',SignalMean);
    else
        fprintf('Pyrometer Signal:                              %d      [A]\n',SignalMean);
    end
    PowerMean=double(int(   ((Emissivity*2*h*c^2) / (Lambda^5*(exp((h*c)/(k*Lambda*Temperature)))))*SolidAngleAreaMean   ,'Lambda',LambdaLower,LambdaUpper) );
    fprintf('Power Mean (W):                                %d      [W]\n\n',PowerMean)
end



%% 
%**********************************************************************************************
%   COMPUTING PbS & PbSe FIBER-PHOTODIODE COUPLING EFFICIENCY USING THE MEAN OF THE WAVELENGTHS
%**********************************************************************************************

fprintf('COUPLING EFFICIENCY:\n');
if or(strcmp(PdMaterial,'PbSe'),strcmp(PdMaterial,'PbS'))
    fprintf('Using PbSe and PbS... calculating coupling efficiency:\n');
    Width=1;
    Height=1;
    Separation=0.455;
    [PhotodiodeFffectiveArea,R2]=FunctionEfficiencyConectorization(Width,Height,Separation,AceptanceAngleMean,Diameter,DistanceConnector);
    fprintf('Photodiode Effective Area:                     %d      [mm^2]\n',PhotodiodeFffectiveArea*1000000);
    fprintf('Max spot radius that covers both PD areas:     %d      [mm]\n',R2*1000);
    SpotRadiusMeanOut=DistanceConnector*tan(AceptanceAngleMean)+Diameter/2;
    fprintf('Spot radius:                                   %d      [mm]\n',SpotRadiusMeanOut*1000);
    SpotAreaMeanOut=pi*(SpotRadiusMeanOut)^2;
    fprintf('Spot Area:                                     %d      [mm^2]\n',SpotAreaMeanOut*1000000);
    CouplingEfficience=PhotodiodeFffectiveArea/SpotAreaMeanOut;
    fprintf('Coupling Efficience:                           %d      []\n\n',CouplingEfficience);
else
    CouplingEfficience=1;
    fprintf('Coupling Efficience:                           %d                 []\n\n',CouplingEfficience);
end


%% 
%**************************************************************************
%   COMPUTING LOSSES IN PLANCK FUNCTION
%**************************************************************************

if strcmp(Mean,'Off')
    % THEORETICAL RESULTS USING A SYMBOLIC CALCULATION
    fprintf('RESULTS USING THE EXACT NA:\n');
    Signal=SignalExact*SystemLosses*CouplingEfficience;
    if or(strcmp(PdMaterial,'PbSe'),strcmp(PdMaterial,'PbS'))
        fprintf('Pyrometer Signal with losses:                  %d      [V]\n',Signal);
    else
        fprintf('Pyrometer Signal with losses:                  %d      [A]\n',Signal);
    end
    PowerW=PowerExact*SystemLosses*CouplingEfficience;
    fprintf('Pyrometer Optical Power with losses:           %d      [W]\n',PowerW);
    PowerdBm=10*log10(1000*PowerW);
    fprintf('Pyrometer Optical Power with losses:           %d     [dBm]\n\n',PowerdBm);
else
    % THEORETICAL RESULTS USING AN APPROXIMATION
    fprintf('RESULTS USING THE NA MEAN:\n');
    Signal=SignalMean*SystemLosses*CouplingEfficience;
    if or(strcmp(PdMaterial,'PbSe'),strcmp(PdMaterial,'PbS'))
        fprintf('Pyrometer Signal with losses:                  %d      [V]\n',Signal);
    else
        fprintf('Pyrometer Signal with losses:                  %d      [A]\n',Signal);
    end
    PowerW=PowerMean*SystemLosses*CouplingEfficience;
    fprintf('Pyrometer Optical Power with losses:           %d      [W]\n',PowerW);
    PowerdBm=10*log10(1000*PowerW);
    fprintf('Pyrometer Optical Power with losses:           %d     [dBm]\n\n',PowerdBm);
end


end
