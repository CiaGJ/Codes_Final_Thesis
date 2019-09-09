function [DR_core,DDistance,DNA,DP]=ErrorPower(Erf,Et,ENA,Mean,PdMaterial,LambdaUpper,LambdaLower,Diameter,Distance,DistanceConnector,Temperature,Emissivity,Dob)

%FORMAT NUMBER
format shortEng


%UNITS CONVERSION.
Temperature=Temperature+273.15;             %Convert: ºC    ->  K
Distance=Distance*1e-3;                     %Convert: mm    ->  m
DistanceConnector=DistanceConnector*1e-3;   %Convert: mm    ->  m
Diameter=Diameter*1e-6;                     %Convert: um    ->  m
LambdaLower=LambdaLower*1e-9;               %Convert: nm    ->  m
LambdaUpper=LambdaUpper*1e-9;               %Convert: nm    ->  m
%Length=Length*1e-3;                         %Convert: m     ->  km
Erf=Erf*1e-6;                               %Convert: um    ->  m 
Et=Et*1e-3;                                %Convert: mm    ->  m

%VARIABLES
syms Lambda

%%  ACEPTANCE ANGLE & SOLID ANGLE

[NA,~,~,AceptanceAngle]=FunctionAcceptanceAngle(Mean,LambdaUpper,LambdaLower,Diameter,Distance,Dob);

%%   RESPONSIVITY
[Responsivity,~]=FunctionResponsivity(PdMaterial,Diameter,DistanceConnector,AceptanceAngle);

%% PLANCK FUNCTION
[~,Power]=FunctionPlanckNoSolidAngle(Responsivity,Emissivity,Temperature,LambdaLower,LambdaUpper,PdMaterial);

%% ERROR CALCULATION
[D1]=d_dr_core(Diameter,Distance,NA);
DR_core=D1*Power;
disp('\partial / \partial rf:');
disp(DR_core);
DR_core=DR_core*Erf;
fprintf('Error R_core:\n');
disp(DR_core);

[D2]=d_dDistance(Diameter,Distance,NA);
DDistance=D2*Et;
disp('\partial / \partial t:');
disp(DDistance);
DDistance=DDistance*Et;
fprintf('Error Distance:\n');
disp(DDistance);

[D3]=d_dNA(Diameter,Distance,NA);
DNA=D3*ENA;
disp('\partial/\partial NA:');
disp(DNA);
DNA=DNA*ENA;
fprintf('Error NA:\n');
disp(DNA);

DP=(DR_core+DDistance+DNA);
fprintf('Error Power:\n');
disp(DP);
end