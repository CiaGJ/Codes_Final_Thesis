function [Responsivity,CouplingEfficience]=FunctionResponsivity(PdMaterial,Diameter,DistanceConnector,AceptanceAngle)
syms Lambda
%RESPONSIVITY OF THE PHOTODETECTOR'S MATERIAL.
switch PdMaterial
    case 'Si' %RESPONSIVITY Si
        fprintf('RESPONSIVITY Si\n\n');
        load('Data/ResponsivityValuesSi.mat')
        load('Data/WavelengthValuesSi.mat')
        Curve=polyfit(WavelengthValuesSi,ResponsivityValuesSi,14);
        Responsivity=poly2sym(Curve,Lambda);
        CouplingEfficience=1;
        fprintf('Coupling Efficience:\t %d[]\n\n',CouplingEfficience);
    case 'Ge' %RESPONSIVITY Ge
        fprintf('RESPONSIVITY Ge\n\n');
        load('Data/ResponsivityValuesGe.mat')
        load('Data/WavelengthValuesGe.mat')
        Curve=polyfit(WavelengthValuesGe,ResponsivityValuesGe,13);
        Responsivity=poly2sym(Curve,Lambda);
        CouplingEfficience=1;
        fprintf('Coupling Efficience:\t %d[]\n\n',CouplingEfficience);
    case 'InGaAsEx' %RESPONSIVITY InGaAs Extended
        fprintf('RESPONSIVITY InGaAs EXTENDED\n\n');
        load('Data/ResponsivityValuesInGaAsEx.mat')
        load('Data/WavelengthValuesInGaAsEx.mat')
        Curve=polyfit(WavelengthValuesInGaAsEx,ResponsivityValuesInGaAsEx,15);
        Responsivity=poly2sym(Curve,Lambda);
        CouplingEfficience=1;
        fprintf('Coupling Efficience:\t %d[]\n\n',CouplingEfficience);
    case 'PbS' %RESPONSIVITY PbS
        fprintf('RESPONSIVITY PbS\n\n');
        load('Data/ResponsivityValuesPbS.mat')
        load('Data/WavelengthValuesPbS.mat')
        Curve=polyfit(WavelengthValuesPbS,ResponsivityValuesPbS,8);
        Responsivity=poly2sym(Curve,Lambda);
        [CouplingEfficience]=FunctionCouplingEfficience(AceptanceAngle,Diameter,DistanceConnector);
    case 'PbSe' %RESPONSIVITY PbSe
        fprintf('RESPONSIVITY PbSe\n\n');
        load('Data/ResponsivityValuesPbSe.mat')
        load('Data/WavelengthValuesPbSe.mat')
        Curve=polyfit(WavelengthValuesPbSe,ResponsivityValuesPbSe,10);
        Responsivity=poly2sym(Curve,Lambda);
        [CouplingEfficience]=FunctionCouplingEfficience(PdMaterial,AceptanceAngle,Diameter,DistanceConnector);
    case 'InGaAs' %RESPONSIVITY InGaAs
        fprintf('RESPONSIVITY InGaAs\n\n');
        load('Data/ResponsivityValuesInGaAs.mat')
        load('Data/WavelengthValuesInGaAs.mat')
        Curve=polyfit(WavelengthValuesInGaAs,ResponsivityValuesInGaAs,12);
        Responsivity=poly2sym(Curve,Lambda);
        CouplingEfficience=1;
        fprintf('Coupling Efficience:\t %d[]\n\n',CouplingEfficience);
    case 'InSb' %RESPONSIVITY InSb
        % http://www.kolmartech.com/kisdp.htm
        fprintf('RESPONSIVITY InSb\n\n');
        load('Data/ResponsivityValuesInSb.mat')
        load('Data/WavelengthValuesInSb.mat')
        Curve=polyfit(WavelengthValuesInSb,ResponsivityValuesInSb,12);
        Responsivity=poly2sym(Curve,Lambda);
        CouplingEfficience=1;
        fprintf('Coupling Efficience:\t %d[]\n\n',CouplingEfficience);
    otherwise
        error('Error. For the material of the photodector entered there is no data');
end
end