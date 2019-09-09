function [D3]=d_dNA(Diameter,Distance,NA)
% Esta funcion calcula la derivada parcial del angulo solido con respecto a
% la apertura numérica de la fibra.
fprintf('d_dNA\n');

rf=Diameter/2;
t=Distance;

%% Termino 1
gun2=@(u)((t.^2.*u)./((t.^2+u.^2).^2));
A=integral(gun2,0,2.*rf-t.*tan(asin(NA)));
T1=4.*pi.^2.*((t)./(sqrt((1-NA.^2).^3))).*(t.*tan(asin(NA))-rf).*A;
fprintf('T1:'); disp(T1);

%% Termino 2
fun3=@(u)(acos((((t.*tan(asin(NA))-rf).^2-rf.^2+u.^2)./(2.*u.*(t.*tan(asin(NA))-rf)))).*((t.^2.*u)./((t.^2+u.^2).^2)));
A1=integral(@(u)fun3(u),2.*rf-t.*tan(asin(NA)),t.*tan(asin(NA)));
T2=4.*pi.*(t.*tan(asin(NA))-rf).*((t)./(sqrt((1-NA.^2).^3))).*A1;
fprintf('T2:\n'); disp(T2);

%% Termino 3
gun2=@(u)((t.^2.*u)./((t.^2+u.^2).^2));
A=integral(gun2,0,2.*rf-t.*tan(asin(NA)));
T3=-4.*pi.^2.*((t)./(sqrt((1-NA.^2).^3))).*(t.*tan(asin(NA))-rf).*A;
fprintf('T3:\n'); disp(T3);

%% Termino 4
fun5=@(r)(r.*((t)./(sqrt((1-NA.^2).^3))).*acos((r.^2-rf.^2+(t.*tan(asin(NA))).^2)./(2.*(t.*tan(asin(NA))).*r)).*((t.^3.*(tan(asin(NA))).^2)./(t.^2+(t.*tan(asin(NA))).^2).^2));
G1=integral(fun5,t.*tan(asin(NA))-rf,rf);

fun3=@(u)(acos((((t.*tan(asin(NA))-rf).^2-rf.^2+u.^2)./(2.*u.*(t.*tan(asin(NA))-rf)))).*((t.^2.*u)./((t.^2+u.^2).^2)));
A1=integral(@(u)fun3(u),2.*rf-t.*tan(asin(NA)),t.*tan(asin(NA)));
G2=(t.*tan(asin(NA))-rf).*((t)./(sqrt((1-NA.^2).^3))).*A1;

T4=4*pi*(G1-G2);
fprintf('T4:\n'); disp(T4);

%% Termino 5
fun5=@(r)(r.*((t)./(sqrt((1-NA.^2).^3))).*acos((r.^2-rf.^2+(t.*tan(asin(NA))).^2)./(2.*(t.*tan(asin(NA))).*r)).*((t.^3.*(tan(asin(NA))).^2)./(t.^2+(t.*tan(asin(NA))).^2).^2));
G1=integral(fun5,rf,t.*tan(asin(NA))+rf);

T5=4*pi*G1;
fprintf('T4:\n'); disp(T5);

%% Suma total
D3=T1+T2+T3+T4+T5;
fprintf('Total:\n');
disp(D3);

end