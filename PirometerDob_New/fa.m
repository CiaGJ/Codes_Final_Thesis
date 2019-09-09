function [T1]=fa(t,rmax,Limit)
% Caso I.1

fun=@(r)(r.*(2.*pi.^2.*rmax.^2)./(t.^2+rmax.^2));
xmax=Limit;
T1=integral(@(r)fun(r),0,xmax);

end