function [Signal,PowerW,PowerdBm]=FunctionPlanckLosses(Power,Signal,SystemLosses,CouplingEfficience,PdMaterial,Mean)

if strcmp(Mean,'Off')
    % THEORETICAL RESULTS USING A SYMBOLIC CALCULATION
    fprintf('RESULTS USING THE EXACT NA:\n');
    Signal=Signal*SystemLosses*CouplingEfficience;
    if or(strcmp(PdMaterial,'PbSe'),strcmp(PdMaterial,'PbS'))
        fprintf('Pyrometer Signal with losses:\t %d [V]\n',Signal);
    else
        fprintf('Pyrometer Signal with losses:\t %d [A]\n',Signal);
    end
    PowerW=Power*SystemLosses*CouplingEfficience;
    fprintf('Pyrometer Optical Power with losses:\t %d [W]\n',PowerW);
    PowerdBm=10*log10(1000*PowerW);
    fprintf('Pyrometer Optical Power with losses:\t %d [dBm]\n\n',PowerdBm);
else
    % THEORETICAL RESULTS USING AN APPROXIMATION
    fprintf('RESULTS USING THE NA MEAN:\n');
    Signal=Signal*SystemLosses*CouplingEfficience;
    if or(strcmp(PdMaterial,'PbSe'),strcmp(PdMaterial,'PbS'))
        fprintf('Pyrometer Signal with losses:\t %d [V]\n',Signal);
    else
        fprintf('Pyrometer Signal with losses:\t %d [A]\n',Signal);
    end
    PowerW=Power*SystemLosses*CouplingEfficience;
    fprintf('Pyrometer Optical Power with losses:\t %d [W]\n',PowerW);
    PowerdBm=10*log10(1000*PowerW);
    fprintf('Pyrometer Optical Power with losses:\t %d [dBm]\n\n',PowerdBm);
end
end


