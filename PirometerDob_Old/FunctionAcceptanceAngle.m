function [SolidAngleArea,AceptanceAngle,SpotDiameter]=FunctionAcceptanceAngle(Mean,LambdaLower,LambdaUpper,Diameter,Distance,Dob)
syms Lambda
fprintf('ACEPTANCE ANGLE AND SOLID ANGLE:\n');
% SELLMEIER COEFFICIENTS OF A SILICA FIBER
% Fiber: Graded-index glass-based multimode optical fiber with a SiO2 core doped with 6.3mol-% GeO2and a SiO2 cladding
% Reference: D. S. Montero, "Multimode Fibre Broadband Access and Self-Referencing Sensor Networks," Electronics Technlogy Department, Universidad Carlos III de Madrid, Leganés (Spain), 2011.
load('Data/SellmeierCoefSilicaFiber.mat');

% Reference: T. Ueda, A. Hosokawa, and A. Yamamoto, "Studies on Temperature
% of Abrasive Grains in Grinding—Application of Infrared Radiation Pyrometer,
% " Journal of Manufacturing Science and Engineering, vol. 107, pp. 127-133, 1985.

if strcmp(Mean,'Off')
    % ACEPTANCE ANGLE AS A FUNCTION OF THE WAVELENGTH
    i=1;
    AceptanceAngleVector=zeros(1);
    LambdaVector=zeros(1);
    for LambdaEval=LambdaLower:0.25e-9:LambdaUpper
        ncore=double(sqrt(1+(LambdaEval*1e+6)^2*((A11)/((LambdaEval*1e+6)^2-L11^2)+((A12)/((LambdaEval*1e+6)^2-L12^2))+((A13)/((LambdaEval*1e+6)^2-L13^2)))));
        ncladding=double(sqrt(1+(LambdaEval*1e+6)^2*((A21)/((LambdaEval*1e+6)^2-L21^2)+((A22)/((LambdaEval*1e+6)^2-L22^2))+((A23)/((LambdaEval*1e+6)^2-L23^2)))));
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
    SpotDiameter=NaN;
    fprintf('Numerical Aperture:\t No value\n');
    fprintf('Aceptance Angle:\t No value\n');
    fprintf('Spot Diameter:\t No value\n');
    
    % SOLID ANGLE USING THE MEAN OF THE WAVELENGTHS
    [SolidAngleArea]=FunctionSpotDiameter(Dob,SpotDiameter,Distance,AceptanceAngle,Diameter);
    fprintf('Solid Angle:\t No value\n');
else
    % NUMERICAL APERTURE USING THE MEAN OF BOTH WAVELENGTHS
    LambdaEval=(LambdaUpper+LambdaLower)/(2);
    LambdaEval=(LambdaEval*1e+6)^2;
    ncore=double(sqrt(1+(LambdaEval)*((A11)/(LambdaEval-L11^2)+((A12)/(LambdaEval-L12^2))+((A13)/(LambdaEval-L13^2)))));
    ncladding=double(sqrt(1+(LambdaEval)*((A21)/(LambdaEval-L21^2)+((A22)/(LambdaEval-L22^2))+((A23)/(LambdaEval-L23^2)))));
    NA=sqrt(ncore^2-ncladding^2);
    %NA=0.29;
    fprintf('Numerical Aperture:\t %d []\n',NA);
    
    % ACEPTANCE ANGLE USING THE MEAN OF BOTH WAVELENGTHS
    AceptanceAngle=asin(NA);
    fprintf('Aceptance Angle:\t %d [º]\n',AceptanceAngle);
    
    % MEASURING AREA COVERED BY THE ACEPTANCE ANGLE USING THE MEAN OF THE WAVELENGTHS
    SpotDiameter=(Distance*tan(AceptanceAngle)+Diameter/2)*2;
    fprintf('Spot Diameter:\t %d [m]\n',SpotDiameter);
    
    % SOLID ANGLE AS A FUNCTION OF THE WAVELENGTH
    [SolidAngleArea]=FunctionSpotDiameter(Dob,SpotDiameter,Distance,AceptanceAngle,Diameter);
    fprintf('Solid Angle:\t %d [Sr*m^2]\n',SolidAngleArea);
end
end

