function [Signal,PowerW,PowerdBm]=Pirometer7(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Distance,DistanceConnector,Length,Temperature,Emissivity)
%%   PROGRAM SETTINGS AND UNIT CONVERSIONS
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

%VARIABLES
syms Lambda


%%   RESPONSIVITY
[Responsivity,CouplingEfficience]=FunctionResponsivity(PdMaterial,Diameter,DistanceConnector);

%%   INSERTION LOSSES
[SystemLosses,~]=FunctionLosses(Losses,PdMaterial,LambdaUpper,LambdaLower,Length);

%%  ACEPTANCE ANGLE
[SolidAngleArea,~,~]=FunctionAcceptanceAngle(Mean,LambdaLower,LambdaUpper,Diameter,Distance);


%%   PLANCK FUNCTION
[Signal,Power]=FunctionPlanck(Responsivity,Emissivity,Temperature,SolidAngleArea,LambdaLower,LambdaUpper,PdMaterial);

%%  COMPUTING LOSSES IN PLANCK FUNCTION
[Signal,PowerW,PowerdBm]=FunctionPlanckLosses(Power,Signal,SystemLosses,CouplingEfficience,PdMaterial,Mean);

end