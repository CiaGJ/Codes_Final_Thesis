function [T]=IterationDobDist(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Dob,Distance,DistanceConnector,Length,Temperature,Emissivity) 
% Esta función se utiliza para calcular la radianza espectral para un
% intervalo de diametros a una distancia fija y con el resto de parámetros
% constantes.

n = length(Dob);
fprintf('Distance: %d\n',Distance);
ResultSignal=zeros(n,1);
ResultPowerdBm=zeros(n,1);
ResultPowerW=zeros(n,1);
SpotDiameter=zeros(n,1);
SolidAngleArea=zeros(n,1);

tic
for i=1:1:n
    fprintf('Iteration: %d of %d\n',i,n);
    fprintf('Diameter target: %d\n',Dob(i)); 
    Dot=Dob(i);
    [Signal,PowerW,PowerdBm,SpotDiameter(i),SolidAngleArea(i)]=PirometerDob(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Dot,Distance,DistanceConnector,Length,Temperature,Emissivity);
    ResultSignal(i)=Signal;
    ResultPowerW(i)=PowerW;
    ResultPowerdBm(i)=PowerdBm;
end
toc

T=table(Dob,SolidAngleArea,ResultSignal,ResultPowerW);

end