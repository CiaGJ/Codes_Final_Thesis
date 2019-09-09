function [T]=IterationTempDiamenterNoise(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Distance,DistanceConnector,Length,InitialTemperature,StepTemperature,FinalTemperature,Emissivity,Noise)
%ResultSignal,ResultPowerW,ResultPowerdBm,TemperatureVector
%fprintf('Distance: %d',Distance);n
FinalValue=((FinalTemperature-InitialTemperature)/(StepTemperature));
TemperatureVector=zeros(1);
n = length(Diameter);
ResultPowerNoiseW=zeros(n,FinalValue);
ResultPowerW=zeros(n,FinalValue);

tic

for j=0:1:n-1
for i=0:1:FinalValue
    fprintf('Iteration1: %d of %d\n',j+1,n);
    fprintf('Diameter: %d\n',Diameter(j+1));
    fprintf('Iteration2: %d of %d\n',i,FinalValue);
    Temperature=InitialTemperature+StepTemperature*i;
    [~,PowerW,~]=Pirometer7(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter(j+1),Distance,DistanceConnector,Length,Temperature,Emissivity);
    ResultPowerW(j+1,i+1)=PowerW;
    ResultPowerNoiseW(j+1,i+1)=PowerW+Noise;
    TemperatureVector(j+1,i+1)=Temperature;
end

end

toc

ResultPower=[ResultPowerW' ResultPowerNoiseW'];
TemperatureVector=TemperatureVector';
T=table(TemperatureVector(:,1),ResultPower);

end

