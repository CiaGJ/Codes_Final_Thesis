function [T]=IterationDist(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Dob,Distance,DistanceConnector,Length,Temperature,Emissivity) 

n = length(Distance);
fprintf('Diameter target: %d\n',Dob);
ResultSignal=zeros(n,1);
ResultPowerdBm=zeros(n,1);
ResultPowerW=zeros(n,1);
SpotDiameter=zeros(n,1);
SolidAngleArea=zeros(n,1);

tic
for i=1:1:n
    fprintf('Iteration: %d of %d\n',i,n);
    fprintf('Distance: %d\n',Distance(i)); 
    Dist=Distance(i);
    [Signal,PowerW,PowerdBm,SpotDiameter(i),SolidAngleArea(i)]=PirometerDob(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Dob,Dist,DistanceConnector,Length,Temperature,Emissivity);
    ResultSignal(i)=Signal;
    ResultPowerW(i)=PowerW;
    ResultPowerdBm(i)=PowerdBm;
    
    
    loglog(Dist,ResultPowerW(i),'bo');
    grid on
    hold on
end
toc
T=table(Distance,SolidAngleArea,SpotDiameter,ResultSignal,ResultPowerW);
%title('Potencia Óptica vs. Distancia hasta el óbjetivo');
%xlabel('Diámetro Objetivo [um]');
%ylabel('Potencia Óptica [dB*m]');
%hold off

end