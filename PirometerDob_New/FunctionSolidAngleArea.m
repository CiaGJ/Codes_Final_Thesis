function [SolidAngleArea,rmax]=FunctionSolidAngleArea(t,Diameter,NA,SpotDiameter,Dob)

rf=Diameter/2;
ran=SpotDiameter/2;
%ran=t*tan(asin(AN))+rf
rob=Dob/2;

rmax=ran-rf;
fprintf('Radius beta max: %d\n',rmax);

if rmax<=rf
    [T1,T2,T3,T4]=casoI(t,rf,rob,rmax);
    SolidAngleArea=T1+T2+T3+T4;
    fprintf('Solid Angle Area Caso I:') 
    disp(SolidAngleArea);
elseif rmax<=2*rf
    [T1,T2,T3,T4,T5]=casoII(t,rf,rob,rmax);
    SolidAngleArea=T1+T2+T3+T4+T5;
    fprintf('Solid Angle Area Caso II:') 
    disp(SolidAngleArea);
elseif rmax>2*rf
    [T1,T2,T3,T4]=casoIII(t,NA,rf,rob,ran);
    SolidAngleArea=T1+T2+T3+T4;
    fprintf('Solid Angle Area Caso III:') 
    disp(SolidAngleArea);
end
end