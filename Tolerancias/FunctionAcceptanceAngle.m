function [NA,SolidAngleArea,SpotDiameter,AceptanceAngle]=FunctionAcceptanceAngle(Mean,LambdaUpper,LambdaLower,Diameter,Distance,Dob)
% SELLMEIER COEFFICIENTS OF A SILICA FIBER
% Fiber: Graded-index glass-based multimode optical fiber with a SiO2 core doped with 6.3mol-% GeO2and a SiO2 cladding
% Reference: D. S. Montero, "Multimode Fibre Broadband Access and Self-Referencing Sensor Networks," Electronics Technlogy Department, Universidad Carlos III de Madrid, Legan?s (Spain), 2011.

% Reference: T. Ueda, A. Hosokawa, and A. Yamamoto, "Studies on Temperature
% of Abrasive Grains in Grinding?Application of Infrared Radiation Pyrometer,
% " Journal of Manufacturing Science and Engineering, vol. 107, pp. 127-133, 1985.

load('Data/SellmeierCoefSilicaFiber.mat');

fprintf('ACEPTANCE ANGLE:\n');

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
    
    % SOLID ANGLE AS A FUNCTION OF THE WAVELENGTH
    fprintf('SOLID ANGLE:\n');
    SolidAngleArea=((pi^2*(Diameter^2))/(8))*(1-cos(2*AceptanceAngle));
    fprintf('Solid Angle:                                   No value        \n\n');
    
else
    % NUMERICAL APERTURE USING THE MEAN OF BOTH WAVELENGTHS
    LambdaMean=(LambdaUpper+LambdaLower)/(2);
    ncoreMean=(1+((A11*(LambdaMean*1e+6)^2)/((LambdaMean*1e+6)^2-L11^2))+((A12*(LambdaMean*1e+6)^2)/((LambdaMean*1e+6)^2-L12^2))+((A13*(LambdaMean*1e+6)^2)/((LambdaMean*1e+6)^2-L13^2)))^(1/2);
    ncladdingMean=(1+((A21*(LambdaMean*1e+6)^2)/((LambdaMean*1e+6)^2-L21^2))+((A22*(LambdaMean*1e+6)^2)/((LambdaMean*1e+6)^2-L22^2))+((A23*(LambdaMean*1e+6)^2)/((LambdaMean*1e+6)^2-L23^2)))^(1/2);
    NA=sqrt(ncoreMean^2-ncladdingMean^2);
    fprintf('Numerical Aperture:                            %d      []\n',NA);

    % ACEPTANCE ANGLE USING THE MEAN OF BOTH WAVELENGTHS
    AceptanceAngle=asin(NA);
    fprintf('Aceptance Angle:                               %d      [?]\n',AceptanceAngle);

    % MEASURING AREA COVERED BY THE ACEPTANCE ANGLE USING THE MEAN OF THE WAVELENGTHS
    SpotDiameter=(Distance*tan(AceptanceAngle)+Diameter/2)*2;
    fprintf('Spot Diameter:                                 %d      [mm]\n\n',SpotDiameter*1000);
    
    % SOLID ANGLE USING THE MEAN OF THE WAVELENGTHS
    fprintf('SOLID ANGLE:\n');
    %SolidAngleArea=((pi^2*(Diameter^2))/(8))*(1-cos(2*AceptanceAngle));
    [SolidAngleArea,~]=FunctionSolidAngleArea(Distance,Diameter,NA,SpotDiameter,Dob);
    fprintf('Solid Angle:                                   %d      [Sr*m^2]\n\n',SolidAngleArea);

end

end