function [T]=IterationTempDiamenter(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Distance,DistanceConnector,Length,InitialTemperature,StepTemperature,FinalTemperature,Emissivity)
%ResultSignal,ResultPowerW,ResultPowerdBm,TemperatureVector
%fprintf('Distance: %d',Distance);n
FinalValue=((FinalTemperature-InitialTemperature)/(StepTemperature));
TemperatureVector=zeros(1);
n = length(Diameter);
ResultSignal=zeros(n,FinalValue);
ResultPowerW=zeros(n,FinalValue);
ResultPowerdBm=zeros(n,FinalValue);

tic

for j=0:1:n-1
for i=0:1:FinalValue
    fprintf('Iteration1: %d of %d\n',j+1,n);
    fprintf('Diameter: %d\n',Diameter(j+1));
    fprintf('Iteration2: %d of %d\n',i,FinalValue);
    Temperature=InitialTemperature+StepTemperature*i;
    [Signal,PowerW,PowerdBm]=Pirometer7(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter(j+1),Distance,DistanceConnector,Length,Temperature,Emissivity);
    ResultSignal(j+1,i+1)=Signal;
    ResultPowerW(j+1,i+1)=PowerW;
    ResultPowerdBm(j+1,i+1)=PowerdBm;
    TemperatureVector(j+1,i+1)=Temperature;
end
end

toc

%plot(TemperatureVector,ResultPowerW,'*b');
%grid on
%title(['Optical Power Vs Temperature - ',num2str(Distance) 'mm']);
%xlabel('Temperature [ºC]');
%ylabel('Optical Power [W]');

ResultSignal=ResultSignal';
ResultPowerW=ResultPowerW';
ResultPowerdBm=ResultPowerdBm';
TemperatureVector=TemperatureVector';
T=table(TemperatureVector(:,1),ResultPowerW);
fprintf('\n');
