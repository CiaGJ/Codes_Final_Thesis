function [T1,T2,T3,T4,T5]=casoII(t,rf,rob,rmax)
% Caso II (rf < rmax <= 2*rf)
%rmax=t*tan(asin(NA));
T1=0;T2=0;T3=0;T4=0;T5=0;

if rob<(rmax-rf)
    [T1,T2]=faII(rf,t,rob);
    fprintf('faII:'); disp(T1+T2);
elseif rob<rf
    [T1,T2]=faII(rf,t,rmax-rf);
    fprintf('faII:'); disp(T1+T2);
    [T3,T4]=fbII(rf,t,rmax,rob);
    fprintf('fbII:'); disp(T3+T4);
elseif rob<(rf+rmax)
    [T1,T2]=faII(rf,t,rmax-rf);
    fprintf('faII:'); disp(T1+T2);
    [T3,T4]=fbII(rf,t,rmax,rf);
    fprintf('fbII:'); disp(T3+T4);
    [T5]=fcII(t,rf,rmax,rob);
    fprintf('fcII:'); disp(T5);
else
    [T1,T2]=faII(rf,t,rmax-rf);
    fprintf('faII:'); disp(T1+T2);
    [T3,T4]=fbII(rf,t,rmax,rf);
    fprintf('fbII:'); disp(T3+T4);
    [T5]=fcII(t,rf,rmax,rmax+rf);
    fprintf('fcII:'); disp(T5);
end
end
