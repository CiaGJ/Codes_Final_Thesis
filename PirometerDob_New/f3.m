function [T1,T2]=f3(rf,t,Limit)

% Término 1
%TO DO: Debes generar una integral -> DONE
%fun=@(r)(r.*(2.*pi.^2.*(rf-r).^2)./(t.^2+(rf-r).^2));
xmax=Limit;
%T1=integral(@(r)fun(r),0,xmax);

% T1=2*pi^2*(0.5*xmax^2-t*xmax*atan(xmax/t)+0.5*t^2*log(1+(xmax/t)^2));
T1=2*pi^2*(rf*xmax-t*rf*atan(xmax/t)+0.5*t^2*log(1+(xmax/t)^2)-0.5*xmax^2);


% Término 2

U=0;
R=0;
dr=(0.2)^0.5*1e-7;


for r=dr:dr:Limit

fun=@(u)((acos((r^2-rf^2+u.^2)./(2.*u*r))).*(t^2.*u./(t^2+u.^2).^2));
U=integral(@(u)fun(u),rf-r,rf+r);

R=U*r+R;

end

T2=4*pi*R*dr;

end