function [CouplingEfficience]=FunctionCouplingEfficience(AceptanceAngle,Diameter,DistanceConnector)
%   COMPUTING PbS & PbSe FIBER-PHOTODIODE COUPLING EFFICIENCY USING THE MEAN OF THE WAVELENGTHS
fprintf('COUPLING EFFICIENCY:\n');

fprintf('Using PbSe and PbS... calculating coupling efficiency:\n');
Width=1;
Height=1;
Separation=0.455;
[PhotodiodeFffectiveArea,R2]=FunctionEfficiencyConectorization(Width,Height,Separation,AceptanceAngle,Diameter,DistanceConnector);
fprintf('Photodiode Effective Area:                     %d      [mm^2]\n',PhotodiodeFffectiveArea*1000000);
fprintf('Max spot radius that covers both PD areas:     %d      [mm]\n',R2*1000);
SpotRadiusMeanOut=DistanceConnector*tan(AceptanceAngleMean)+Diameter/2;
fprintf('Spot radius:                                   %d      [mm]\n',SpotRadiusMeanOut*1000);
SpotAreaMeanOut=pi*(SpotRadiusMeanOut)^2;
fprintf('Spot Area:                                     %d      [mm^2]\n',SpotAreaMeanOut*1000000);
CouplingEfficience=PhotodiodeFffectiveArea/SpotAreaMeanOut;
fprintf('Coupling Efficience:                           %d      []\n\n',CouplingEfficience);
end


