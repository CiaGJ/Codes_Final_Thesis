function [T2,T3]=fbI(rf,t,rmax,Limit)
% Caso I.2

% Término 1
% Este termino esta mal, la u no tiene limites constantes, dependen de r,
% por lo tanto no se puede calcular así, ademas de otras cosas

% fun=@(r)(r.*(2.*pi.^2.*(rf-r).^2)./(t.^2+(rf-r).^2));  
xmax=Limit;

U=0;
R=0;
dr=(0.2)^0.5*1e-7;


for r=rf-rmax:dr:xmax

fun=@(u)((t^2.*u./(t^2+u.^2).^2));
U=integral(@(u)fun(u),0,rf-r);

R=U*r+R;

end

T2=4*pi^2*R*dr;

% Hasta aquí se corrigió

% Término 2


U=0;
R=0;
dr=(0.2)^0.5*1e-7;


for r=rf-rmax:dr:Limit

fun=@(u)((acos((r^2-rf^2+u.^2)./(2.*u*r))).*(t^2.*u./(t^2+u.^2).^2));
U=integral(@(u)fun(u),rf-r,rmax);

R=U*r+R;

end

T3=4*pi*R*dr;

end