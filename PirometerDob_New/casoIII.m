function [T1,T2,T3,T4]=casoIII(t,NA,rf,rob,ran)
% Caso III (rmax > 2*rf)
%rmax=t*tan(asin(NA));
T1=0;T2=0;T3=0;T4=0;

if rob<=rf
    [T1,T2]=f3(rf,t,rob);
    fprintf('f3:'); disp(T1+T2);
elseif rob<=(ran-2*rf)
    [T1,T2]=f3(rf,t,rf);
    fprintf('f3:'); disp(T1+T2);
    [T3]=f2(t,rf,rob);
    fprintf('f2:'); disp(T3);
elseif rob<=ran
    [T1,T2]=f3(rf,t,rf);
    fprintf('f3:'); disp(T1+T2);
    [T3]=f2(t,rf,ran-2*rf);
    fprintf('f2:'); disp(T3);
    [T4]=f1(rf,t,NA,rob);
    fprintf('f1:'); disp(T4);
else
    [T1,T2]=f3(rf,t,rf);
    fprintf('f3:'); disp(T1+T2);
    [T3]=f2(t,rf,ran-2*rf);
    fprintf('f2:'); disp(T3);
    [T4]=f1(rf,t,NA,ran);
    fprintf('f1:'); disp(T4);
end
end