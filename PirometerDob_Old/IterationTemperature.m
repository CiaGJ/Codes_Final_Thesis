function [T]=IterationTemperature(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Distance,DistanceConnector,Length,InitialTemperature,StepTemperature,FinalTemperature,Emissivity)

n = length(Diameter);
FinalValue=((FinalTemperature-InitialTemperature)/(StepTemperature));
TemperatureVector=zeros(1);
ResultPowerW=zeros(n,FinalValue);

tic

for j=0:1:n-1
    for i=0:1:FinalValue
        fprintf('Iteration2: %d of %d\n',j+1,n);
        fprintf('Diameter: %d\n',Diameter(j+1));
        fprintf('Iteration3: %d of %d\n',i,FinalValue);
            
        Temperature=InitialTemperature+StepTemperature*i;
        [~,PowerW,~]=Pirometer6(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter(j+1),Distance,DistanceConnector,Length,Temperature,Emissivity);
        ResultPowerW(j+1,i+1)=PowerW;
        TemperatureVector(i+1)=Temperature;
    end
end
TemperatureVector=TemperatureVector';
ResultPowerW=ResultPowerW';
T=table(TemperatureVector,ResultPowerW);

toc

end
