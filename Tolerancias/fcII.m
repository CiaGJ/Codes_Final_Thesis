function [T5]=fcII(t,rf,rmax,Limit)   % Se asignaba valor a T4, no a T5, se corrigió
% Caso II.3

U=0;
R=0;
dr=(0.2)^0.5*1e-7;

for r=rf:dr:Limit

fun=@(u)((acos((r^2-rf^2+u.^2)./(2.*u*r))).*(t^2.*u./(t^2+u.^2).^2));
U=integral(@(u)fun(u),r-rf,rmax);

R=U*r+R;

end

T5=4*pi*R*dr;
end