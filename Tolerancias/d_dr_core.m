function [D1]=d_dr_core(Diameter,Distance,NA)
% Calcula la derivada parcial con respecto al radio de la fibra del ángulo solido.
fprintf('d_dr_core\n');
%dr=(0.2)^0.5*1e-7;
rf=Diameter/2;
t=Distance;

%% Termino 1
gun1=@(r)(r.*((t.^2.*(rf-r))./(t.^2+(rf-r).^2).^2));
G1=integral(@(r)gun1(r),0,t.*tan(asin(NA))-rf);

gun2=@(u)((t.^2.*u)./((t.^2+u.^2).^2));
A=integral(gun2,0,2.*rf-t.*tan(asin(NA)));
G2=(t.*tan(asin(NA))-rf).*A;

T1=4.*pi.^2.*(G1-G2);
fprintf('T1:'); disp(T1);

%% Termino 2
fun1=@(r,u)(r.*((t.^2.*u)./((t.^2+u.^2).^2)).*((rf)./(r.*u.*sqrt(1-((r.^2-rf.^2+u.^2)./(2.*r.*u)).^2))));
ymin=@(r)(rf-r);
ymax=@(r)(rf+r);
G1=integral2(fun1,0,t.*tan(asin(NA))-rf,ymin,ymax);
%fprintf('G1:');
%disp(G1);

fun2=@(r)(r.*pi.*((t.^2.*(rf-r))./(t.^2+(rf-r).^2).^2));
G2=integral(@(r)fun2(r),0,t.*tan(asin(NA))-rf);
%fprintf('G2:');
%disp(G2);

fun3=@(u)(acos((((t.*tan(asin(NA))-rf).^2-rf.^2+u.^2)./(2.*u.*(t.*tan(asin(NA))-rf)))).*((t.^2.*u)./((t.^2+u.^2).^2)));
A1=integral(@(u)fun3(u),2.*rf-t.*tan(asin(NA)),t.*tan(asin(NA)));
G3=(t.*tan(asin(NA))-rf).*A1;
%fprintf('G3:');
%disp(G3);

T2=4*pi*(G1-G2-G3);
fprintf('T2:'); disp(T2);

%% Termino 3
gun1=@(r)(r.*((t.^2.*(rf-r))./(t.^2+(rf-r).^2).^2));
G1=integral(@(r)gun1(r),t.*tan(asin(NA))-rf,rf);

gun2=@(u)((t.^2.*u)./((t.^2+u.^2).^2));
A=integral(gun2,0,2.*rf-t.*tan(asin(NA)));
G2=(t.*tan(asin(NA))-rf).*A;


T3=4.*pi.^2.*(G1+G2);
fprintf('T3:'); disp(T3);

%% Termino 4
fun1=@(r,u)(r.*((t.^2.*u)./((t.^2+u.^2).^2)).*((rf)./(r.*u.*sqrt(1-((r.^2-rf.^2+u.^2)./(2.*r.*u)).^2))));
ymin=@(r)(rf-r);
ymax=t.*tan(asin(NA));
G1=integral2(fun1,t*tan(asin(NA))-rf,rf,ymin,ymax);
%fprintf('G1:'); %disp(G1);

fun2=@(r)(r.*pi.*((t.^2.*(rf-r))./(t.^2+(rf-r).^2).^2));
G2=integral(@(r)fun2(r),t*tan(asin(NA))-rf,rf);

fun4=@(u)(acos(u./(2.*rf)).*((t^2.*u)/(t.^2+u.^2).^2));
B1=integral(fun4,0,t.*tan(asin(NA)));
G3=rf.*B1;

fun3=@(u)(acos((((t.*tan(asin(NA))-rf).^2-rf.^2+u.^2)./(2.*u.*(t.*tan(asin(NA))-rf)))).*((t.^2.*u)./((t.^2+u.^2).^2)));
A1=integral(@(u)fun3(u),2.*rf-t.*tan(asin(NA)),t.*tan(asin(NA)));
G4=(t.*tan(asin(NA))-rf).*A1;

T4=4*pi*(G1+G2+G3+G4);
fprintf('T4:'); disp(T4);

%% Termino 5
fun1=@(r,u)(r.*((t.^2.*u)./((t.^2+u.^2).^2)).*((rf)./(r.*u.*sqrt(1-((r.^2-rf.^2+u.^2)./(2.*r.*u)).^2))));
ymin=@(r)(r-rf);
ymax=t.*tan(asin(NA));
G1=integral2(fun1,rf,t*tan(asin(NA))+rf,ymin,ymax);

fun4=@(u)(acos(u./(2.*rf)).*((t^2.*u)/(t.^2+u.^2).^2));
B1=integral(fun4,0,2.*rf);
G2=rf.*B1;

T5=4*pi*(G1-G2);
fprintf('T5:'); disp(T5);

%% Suma total
D1=T1+T2+T3+T4+T5;
fprintf('Total:');
disp(D1);
end