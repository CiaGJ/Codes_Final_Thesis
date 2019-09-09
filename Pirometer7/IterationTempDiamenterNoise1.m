function [TemperatureVector,ResultPowerW]=IterationTempDiamenterNoise1(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter,Distance,DistanceConnector,Length,InitialTemperature,StepTemperature,FinalTemperature,Emissivity,Mode,Limit)

FinalValue=((FinalTemperature-InitialTemperature)/(StepTemperature));
TemperatureVector=zeros(1);
n = length(Diameter);
ResultPowerW=zeros(n,FinalValue);
[R,Noise]=DataMode(Mode);

tic

for j=0:1:n-1
    for i=0:1:FinalValue
        fprintf('Iteration1: %d of %d\n',j+1,n);
        fprintf('Diameter: %d\n',Diameter(j+1));
        fprintf('Iteration2: %d of %d\n',i,FinalValue);
        Temperature=InitialTemperature+StepTemperature*i;
        [~,PowerW,~]=Pirometer7(Mean,Losses,PdMaterial,LambdaUpper,LambdaLower,Diameter(j+1),Distance,DistanceConnector,Length,Temperature,Emissivity);
        TemperatureVector(j+1,i+1)=Temperature;
        if PowerW>=Limit/R	     
            ResultPowerW(j+1,i+1)=Limit/R;	          
        else	       
            ResultPowerW(j+1,i+1)=Noise/R+PowerW;
        end
    end
end

toc

ResultPowerW=ResultPowerW';
TemperatureVector=TemperatureVector';

end

