function [D2]=d_dDistance(Diameter,Distance,NA)
% Esta funcion calcula la derivada parcial del angulo solido con respecto a
% la distancia de la fibra con respecto a la superficie a medir.
fprintf('d_dDistance\n');

rf=Diameter/2;
t=Distance;

%% Termino 1
gun1=@(r,u)(r.*((2.*t.*u.*(u.^2-t.^2).^2)./(u.^2+t.^2).^3));
ymax=@(r)(rf-r);
ymin=0;
G1=integral2(gun1,0,t.*tan(asin(NA))-rf,ymin,ymax);

gun2=@(u)((t.^2.*u)./((t.^2+u.^2).^2));
A=integral(gun2,0,2.*rf-t.*tan(asin(NA)));
G2=t.*tan(asin(NA)).*(t.*tan(asin(NA))-rf).*A;

T1=4.*pi.^2.*(G1+G2);
fprintf('T1:\n'); disp(T1);

%% Termino 2
fun1=@(r,u)(r.*(acos((r.^2-rf.^2+u.^2)./(2.*u.*r)).*((2.*t.*u.*(u.^2-t.^2).^2)./(u.^2+t.^2).^3)));
ymin=@(r)(rf-r);
ymax=@(r)(rf+r);
G1=integral2(fun1,0,t.*tan(asin(NA))-rf,ymin,ymax);

fun3=@(u)(acos((((t.*tan(asin(NA))-rf).^2-rf.^2+u.^2)./(2.*u.*(t.*tan(asin(NA))-rf)))).*((t.^2.*u)./((t.^2+u.^2).^2)));
A1=integral(@(u)fun3(u),2.*rf-t.*tan(asin(NA)),t.*tan(asin(NA)));
G2=tan(asin(NA)).*(t.*tan(asin(NA))-rf).*A1;

T2=4*pi*(G1+G2);
fprintf('T2:\n'); disp(T2);

%% Termino 3
gun1=@(r,u)(r.*((2.*t.*u.*(u.^2-t.^2).^2)./(u.^2+t.^2).^3));
ymax=@(r)(rf-r);
ymin=0;
G1=integral2(gun1,t.*tan(asin(NA))-rf,rf,ymin,ymax);

gun2=@(u)((t.^2.*u)./((t.^2+u.^2).^2));
A=integral(gun2,0,2.*rf-t.*tan(asin(NA)));
G2=t.*tan(asin(NA)).*(t.*tan(asin(NA))-rf).*A;

T3=4.*pi^2.*(G1-G2);
fprintf('T3:\n'); disp(T3);

%% Termino 4
fun1=@(r,u)(r.*(acos((r.^2-rf.^2+u.^2)./(2.*u.*r)).*((2.*t.*u.*(u.^2-t.^2).^2)./(u.^2-t.^2).^3)));
ymin=@(r)(rf-r);
ymax=t.*tan(asin(NA));
G1=integral2(fun1,t.*tan(asin(NA))-rf,rf,ymin,ymax);

fun5=@(r)(r.*acos((r.^2-rf.^2+(t.*tan(asin(NA))).^2)./(2.*(t.*tan(asin(NA))).*r)).*((t.^3.*(tan(asin(NA))).^2)./(t.^2+(t.*tan(asin(NA))).^2).^2));
G2=integral(fun5,t.*tan(asin(NA))-rf,rf);

fun3=@(u)(acos((((t.*tan(asin(NA))-rf).^2-rf.^2+u.^2)./(2.*u.*(t.*tan(asin(NA))-rf)))).*((t.^2.*u)./((t.^2+u.^2).^2)));
A1=integral(@(u)fun3(u),2.*rf-t.*tan(asin(NA)),t.*tan(asin(NA)));
G3=tan(asin(NA)).*(t.*tan(asin(NA))-rf).*A1;

T4=4*pi*(G1+G2-G3);
fprintf('T4:\n'); disp(T4);

%% Termino 5
fun1=@(r,u)(r.*(acos((r.^2-rf.^2+u.^2)./(2.*u.*r)).*((2.*t.*u.*(u.^2-t.^2).^2)./(u.^2-t.^2).^3)));
ymin=@(r)(r-rf);
ymax=t.*tan(asin(NA));
G1=integral2(fun1,rf,t*tan(asin(NA))+rf,ymin,ymax);

fun5=@(r)(r.*acos((r.^2-rf.^2+(t.*tan(asin(NA))).^2)./(2.*(t.*tan(asin(NA))).*r)).*((t.^3.*(tan(asin(NA))).^2)./(t.^2+(t.*tan(asin(NA))).^2).^2));
G2=integral(fun5,rf,t.*tan(asin(NA))+rf);

T5=4*pi*(G1+G2);
fprintf('T5:\n'); disp(T5);

%% Suma total
D2=T1+T2+T3+T4+T5;
fprintf('Total:\n');
disp(D2);
end