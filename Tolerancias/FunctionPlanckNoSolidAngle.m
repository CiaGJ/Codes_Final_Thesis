function [Signal,Power]=FunctionPlanckNoSolidAngle(Responsivity,Emissivity,Temperature,LambdaLower,LambdaUpper,PdMaterial)
%VARIABLES
syms Lambda

%CONSTANTS.
h=6.626068e-34;
k=1.38066e-23;
c=2.997925e+8;

fprintf('PLANCK FUNCTION:\n');
    Signal=double(int(((Responsivity*Emissivity*2*h*c^2)/(Lambda^5*(exp((h*c)/(k*Lambda*Temperature))))),'Lambda',LambdaLower,LambdaUpper));
    if or(strcmp(PdMaterial,'PbSe'),strcmp(PdMaterial,'PbS'))
        fprintf('Pyrometer Signal:\t %d [V]\n',Signal);
    else
        fprintf('Pyrometer Signal:\t %d [A]\n',Signal);
    end
    Power=double(int(((Emissivity*2*h*c^2)/(Lambda^5*(exp((h*c)/(k*Lambda*Temperature))))),'Lambda',LambdaLower,LambdaUpper));
    fprintf('Power (W):\t %d [W]\n\n',Power)
end
