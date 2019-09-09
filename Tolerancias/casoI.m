function [T1,T2,T3,T4]=casoI(t,rf,rob,rmax)
% Caso I (rmax <= r)
T1=0;T2=0;T3=0;T4=0;

if rob<(rf-rmax)
    [T1]=fa(t,rmax,rob);
    fprintf('faI:'); disp(T1);
elseif rob<rf
    [T1]=fa(t,rmax,rf-rmax);
    fprintf('faI:'); disp(T1);
    [T2,T3]=fbI(rf,t,rmax,rob);
    fprintf('fbI:'); disp(T2+T3);
elseif rob<(rf+rmax)
    [T1]=fa(t,rmax,rf-rmax);
    fprintf('faI:'); disp(T1);
    [T2,T3]=fbI(rf,t,rmax,rf);
    fprintf('fbI:'); disp(T2+T3);
    [T4]=fcI(t,rf,rmax,rob);
    fprintf('fcI:'); disp(T4);
else
    [T1]=fa(t,rmax,rf-rmax);
    fprintf('faI:'); disp(T1);
    [T2,T3]=fbI(rf,t,rmax,rf);
    fprintf('fbI:'); disp(T2+T3);
    [T4]=fcI(t,rf,rmax,rf+rmax);
    fprintf('fcI:'); disp(T4);
end

end
