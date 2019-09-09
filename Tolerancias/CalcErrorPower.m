
Diameter = 62.5;
Distance = 0.3;
DistanceConnector = 4;
ENA = 0.015;
Emissivity = 1;
Erf = 2.5;
Et = 0.075;
LambdaLower = 800;
LambdaUpper = 1430;
Length = 0.5;
Losses = 'On';
Mean = 'On';
PdMaterial = 'InGaAs';
Temperature = 650;
Dob=2e3;

[DR_core,DDistance,DNA,DP]=ErrorPower(Erf,Et,ENA,Mean,PdMaterial,LambdaUpper,LambdaLower,Diameter,Distance,DistanceConnector,Temperature,Emissivity,Dob);