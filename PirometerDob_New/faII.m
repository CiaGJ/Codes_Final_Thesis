function [T1,T2]=faII(rf,t,Limit)
% Caso II.1
% Término 1
U=0;
R=0;
dr=(0.2)^0.5*1e-7;

for r=dr:dr:Limit
    fun=@(u)((t^2.*u./(t^2+u.^2).^2));
    U=integral(@(u)fun(u),0,rf-r);
    R=U*r+R;
end

T1=4*pi^2*R*dr;

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