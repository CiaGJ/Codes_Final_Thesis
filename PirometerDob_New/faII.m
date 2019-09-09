function [T1,T2]=faII(rf,t,Limit)
% Caso II.1

% Término 1

% Esta integral no se calcula así, limite de u depende de r

% fun=@(r)(r.*(2.*pi.^2.*(rf-r).^2)./(t.^2+(rf-r).^2));
% T1=integral(@(r)fun(r),0,xmax);


U=0;
R=0;
dr=(0.2)^0.5*1e-7;


for r=dr:dr:Limit

fun=@(u)((t^2.*u./(t^2+u.^2).^2));
U=integral(@(u)fun(u),0,rf-r);



R=U*r+R;
end

T1=4*pi^2*R*dr;

%fprintf('T1:'); disp(T1);

% Hasta aquí se corrigió

% Término 2

U=0;
R=0;
dr=(0.2)^0.5*1e-7;


for r=dr:dr:Limit

fun=@(u)((acos((r^2-rf^2+u.^2)./(2.*u*r))).*(t^2.*u./(t^2+u.^2).^2));
U=integral(@(u)fun(u),rf-r,rf+r);

% He ejecutado la resta del límite superior menos el inferior y me queda
% negativo. Muy posiblemente por esto salgan números imaginarios.
%(rmax)-(rf-r)
%pause

R=U*r+R;

end

T2=4*pi*R*dr;
%fprintf('T2:'); disp(T2);

end