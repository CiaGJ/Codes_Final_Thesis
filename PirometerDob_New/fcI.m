function [T4]=fcI(t,rf,rmax,Limit)
% Caso I.3

U=0;
R=0;
dr=(0.2)^0.5*1e-7;

for r=rf:dr:Limit

fun=@(u)((acos((r^2-rf^2+u.^2)./(2.*u*r))).*(t^2.*u./(t^2+u.^2).^2));
U=integral(@(u)fun(u),r-rf,rmax); %He cambiado el orden del limite inferior pq me salía negativo



R=U*r+R;

end

T4=4*pi*R*dr;
end