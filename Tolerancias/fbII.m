function [T3,T4]=fbII(rf,t,rmax,Limit)
% Caso II.2

% T�rmino 1

% Esta integral no se calcula as�, limite de u depende de r

% fun=@(r)(r.*(2.*pi.^2.*(rf-r).^2)./(t.^2+(rf-r).^2));
% T3=integral(@(r)fun(r),0,xmax);


U=0;
R=0;
dr=(0.2)^0.5*1e-7;


for r=rmax-rf:dr:Limit

fun=@(u)((t^2.*u./(t^2+u.^2).^2));
U=integral(@(u)fun(u),0,rf-r);



R=U*r+R;
end

T3=4*pi^2*R*dr;

% Hasta aqu� se corrigi�

% T�rmino 2

U=0;
R=0;
dr=(0.2)^0.5*1e-7;


for r=rmax-rf:dr:Limit

fun=@(u)((acos((r^2-rf^2+u.^2)./(2.*u*r))).*(t^2.*u./(t^2+u.^2).^2));
U=integral(@(u)fun(u),rf-r,rmax);

R=U*r+R;

end

T4=4*pi*R*dr;

end