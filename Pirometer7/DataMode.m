function [R,Noise]=DataMode(Mode)
switch Mode
    case 'LG'
        R=7*10^7; %[V/W]
        Noise=1.3E-3; %[V]
    case 'HG'
        R=8*10^8; %[V/W]
        Noise=17E-3; %[V]
    otherwise
        error('Error.For the mode entered there is no data');
end
fprintf('V/W ratio: %d [V/W]\n',R);
fprintf('Noise Offset: %d [V]\n',Noise);

end