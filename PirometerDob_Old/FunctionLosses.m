function [SystemLosses,SystemLossesdB]=FunctionLosses(Losses,PdMaterial,LambdaUpper,LambdaLower,Length)
if strcmp(Losses,'Off')
    fprintf('INSERTION LOSSES Off\n\n');
    AdaptorLosses=1;
    WDMLosses=1;
    FiberLosses=1;
else
     if or(strcmp(PdMaterial,'PbSe'),strcmp(PdMaterial,'PbS'))
        fprintf('INSERTION LOSSES: 600nm (PbS) to 4900nm (PbSe)\n');
        AdaptorLosses=1;
        WDMLosses=1;
        FiberLosses=10^((-450*Length)./10);
     else
        fprintf('INSERTION LOSSES: 200nm (Si) to 2640nm (InGaAsEx)\n');
        % Mean of both wavelengths
        MeanLambda=(LambdaUpper-LambdaLower)/(2)+LambdaLower;
        % Insertion Losses. FC Adaptor
        AdaptorLosses=10^((-0.18)./10);
        if MeanLambda<1200*1e-9
            WDMLosses=10^((-0.210324967)./10);
            FiberLosses=10^((-0.58*Length)./10);
        else
            WDMLosses=10^((-0.06590055)./10);
            FiberLosses=10^((-0.28*Length)./10);
        end
     end
end
SystemLosses=FiberLosses*WDMLosses*AdaptorLosses;
SystemLossesdB=abs(10*log10(SystemLosses));
fprintf('System Insertion Losses:\t %d []\n',SystemLosses);
fprintf('System Insertion Losses:\t %d [dB]\n',SystemLossesdB);
end