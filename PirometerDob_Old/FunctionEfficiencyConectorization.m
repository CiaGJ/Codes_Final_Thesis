function [PhotodiodeFffectiveArea,R2]=FunctionEfficiencyConectorization(Width,Height,Separation,AceptanceAngleMean,Diameter,DistanceConnector)

Width=Width*1e-3;                     %Convert: mm    ->  m
Height=Height*1e-3;                   %Convert: mm    ->  m
Separation=Separation*1e-3;           %Convert: mm    ->  m

R2=sqrt((Height/2)^2+(Width+Separation)^2);
MaximumLimit=Width+Separation;
R1=sqrt((Height/2)^2+(Separation)^2);
R3=Separation;

RadiusFiberPhotodetector=DistanceConnector*tan(AceptanceAngleMean)+Diameter/2;
%fprintf('Spot radius NA mean:                           %d      [mm]\n',RadiusFiberPhotodetector*1000);

if RadiusFiberPhotodetector>=R2
    %fprintf('Larger than R2\n');
    AreaEffective=Width*Height;
end
if (RadiusFiberPhotodetector<R2)&&(RadiusFiberPhotodetector>=R1)
    %fprintf('Between R2 and R1\n');
    if MaximumLimit>=RadiusFiberPhotodetector
      
        x1=abs(sqrt(RadiusFiberPhotodetector^2-(Height/2)^2));
        y1=Height/2;
        Alfa1=atan(y1/x1);
        AreaCircle1=Alfa1*RadiusFiberPhotodetector^2;
        AreaTriangle1=2*((x1*y1)/(2));
        
        AreaRectangle1=Height*(x1-Separation);
        
        AreaEffective=AreaCircle1-AreaTriangle1+AreaRectangle1;
    end
    if MaximumLimit<RadiusFiberPhotodetector
        
        x1=abs(sqrt(RadiusFiberPhotodetector^2-(Height/2)^2));
        y1=Height/2;
        Alfa1=atan(y1/x1);
        AreaCircle1=Alfa1*RadiusFiberPhotodetector^2;
        AreaTriangle1=2*((x1*y1)/(2));
        AreaSemiCirle1=AreaCircle1-AreaTriangle1;
        
        y2=abs(sqrt(RadiusFiberPhotodetector^2-(MaximumLimit)^2));
        x2=MaximumLimit;
        Alfa2=atan(y2/x2);
        AreaCircle2=Alfa2*RadiusFiberPhotodetector^2;
        AreaTriangle2=2*((x2*y2)/(2));
        AreaSemiCirle2=AreaCircle2-AreaTriangle2;
        
        AreaRectangle1=(2)*(Height/2)*(x1-Separation);
        
        AreaEffective=AreaSemiCirle1-AreaSemiCirle2+AreaRectangle1;
    end
end
if (RadiusFiberPhotodetector<R1)&&(RadiusFiberPhotodetector>=R3)
    %fprintf('Between R3 and R1\n');
    y1=abs(sqrt(RadiusFiberPhotodetector^2-(Separation)^2));
    x1=Separation;
    Alfa1=atan(y1/x1);
    AreaCircle1=Alfa1*RadiusFiberPhotodetector^2;
    AreaTriangle1=(x1*y1);
    
    AreaEffective=AreaCircle1-AreaTriangle1;
end
if RadiusFiberPhotodetector<R3
    %fprintf('Lower than R3\n');
    AreaEffective=0;
end

PhotodiodeFffectiveArea=AreaEffective;
%fprintf('Photodiode Effective Area:                     %d      [mm^2]\n',PhotodiodeFffectiveArea*1000000);